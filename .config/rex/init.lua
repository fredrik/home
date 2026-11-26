-- Rex configuration, migrated from zellij (~/.config/zellij/config.kdl).
-- tmux, Herdr and Ghostty had no key bindings that carry over.
--
-- zellij's normal mode is Rex with no mode active. The zellij modes pane, tab,
-- resize, move and tmux are exclusive Rex modes; locked is a Rex mode that
-- hands the keys below back to the program in the pane. scroll, search and
-- session have no Rex mode: none of their actions exist in Rex.

-- Custom actions --------------------------------------------------------------

-- zellij: `<action>; SwitchToMode "normal"`.
rex.action{
  name  = "then_normal",
  title = "Run an action and return to normal mode",
  args  = { action = "string", args = "object?" },
  run   = function(ctx, args)
    -- A name with a dot is the client's action. One without is defined here.
    if args.action:find(".", 1, true) then
      rex.client.queue(args.action, args.args or {})
    else
      local _, err = rex.invoke(args.action, args.args or {})
      if err ~= nil then error(err, 0) end
    end
    rex.client.queue("client.mode.exit_all")
  end,
}

-- zellij: `SwitchToMode "<mode>"` pressed inside another mode. Leaves the
-- current mode first, so modes never stack.
rex.action{
  name  = "switch_mode",
  title = "Leave the current mode and enter another",
  args  = { name = "string" },
  run   = function(ctx, args)
    rex.client.queue("client.mode.exit_all")
    rex.client.queue("client.mode.enter", { name = args.name })
  end,
}

-- Rex appends new tabs to the end of the tab bar and has no setting for it.
-- This has the app open its usual new tab, which it also focuses, and starts
-- a helper that moves the tab to just after the one the action was run from.
--
-- The helper is a separate process because the app only opens the tab once
-- the action has returned. Opening the tab from here instead leaves it without
-- focus: the app keeps its own selected tab and doesn't reliably switch to one
-- the server made. If the helper fails, the tab stays at the end.

-- The server's PATH doesn't include the rex command.
local rex_cli = os.getenv("HOME")
  .. "/Library/Application Support/com.superlogical.rex/RexServer"
  .. "/Versions/Current/Rex Server.app/Contents/MacOS/rex"

-- Run with `rex do -e`. Waits up to three seconds for a tab that isn't in
-- `known`, a comma-separated list of window IDs, and moves it in front of
-- the window `before`.
local place_new_tab = [[
  local known = {}
  for id in rex.args.known:gmatch("[^,]+") do known[id] = true end
  for _ = 1, 60 do
    local view = rex.session.view{}
    for _, window in ipairs(view and view.windows or {}) do
      if not known[window.window_id] then
        rex.session.move_window{
          window_id        = window.window_id,
          before_window_id = rex.args.before,
        }
        return
      end
    end
    rex.sleep(0.05)
  end
]]

rex.action{
  name     = "new_tab_beside",
  title    = "New Tab Beside Current",
  keywords = "create tab window add next adjacent after",
  run      = function(ctx, args)
    rex.client.queue("client.tab.new")

    local view = rex.session.view{}
    if view == nil then return end

    -- The tab the action was run from: the one holding the focused pane, or
    -- the session's active tab when Rex doesn't say which pane that is.
    local current = view.active_window_id
    if ctx.block_id ~= nil then
      local described = rex.session.describe_block{ block_id = ctx.block_id }
      if described ~= nil and described.block.window_id ~= nil then
        current = described.block.window_id
      end
    end

    -- The tab that follows it, which the new tab goes in front of. There is
    -- none when the current tab is last, and the new tab needs no moving.
    local following
    local known = {}
    for index, window in ipairs(view.windows) do
      known[#known + 1] = window.window_id
      if window.window_id == current and view.windows[index + 1] ~= nil then
        following = view.windows[index + 1].window_id
      end
    end
    if following == nil then return end

    rex.exec.start({
      rex_cli, "do", "-e", place_new_tab, "-s", view.session_id,
      "before=" .. following, "known=" .. table.concat(known, ","),
    }, { detach = true, stdout = false, stderr = false })
  end,
}

-- Modes -----------------------------------------------------------------------

local modes = { "pane", "tab", "resize", "move", "tmux" }

for _, mode in ipairs(modes) do
  rex.mode(mode, { exclusive = true })
end

-- The key that enters each mode from anywhere but locked, and leaves it again
-- when pressed inside it (in tmux mode, ctrl+b is sent to the program instead).
local mode_keys = {
  pane   = "ctrl+p",
  tab    = "ctrl+t",
  resize = "ctrl+n",
  move   = "ctrl+h",
  tmux   = "ctrl+b",
}

-- Shared bindings: zellij `shared_except "locked"` ----------------------------
-- Bound with no mode (normal) and again inside every mode, as zellij does.
-- In locked mode the same keys go to the program in the pane instead.

local directions = { "left", "down", "up", "right" }
local hjkl = { h = "left", j = "down", k = "up", l = "right" }

-- Option+Left/Right move by word in the program instead of focusing a pane
-- (alt+h and alt+l do that). They are sent as esc b and esc f, which is what
-- Ghostty sends and what zsh binds. Rex's own encoding for them, CSI 1;3D and
-- CSI 1;3C, isn't bound in zsh.
local word_keys = { ["alt+left"] = "alt+b", ["alt+right"] = "alt+f" }

local function bind_shared(prefix)
  for index = 1, 9 do
    rex.bind(prefix .. "ctrl+" .. index, "client.tab.goto", { index = index })
  end
  for _, direction in ipairs({ "up", "down" }) do
    rex.bind(prefix .. "alt+" .. direction, "pane.focus", { direction = direction })
  end
  for key, sent in pairs(word_keys) do
    rex.bind(prefix .. key, "pane.send_key", { key = sent })
  end
  for key, direction in pairs(hjkl) do
    rex.bind(prefix .. "alt+" .. key, "pane.focus", { direction = direction })
  end
  rex.bind(prefix .. "alt+i", "client.tab.move", { direction = "backward" })
  rex.bind(prefix .. "alt+o", "client.tab.move", { direction = "forward" })
  rex.bind(prefix .. "alt+n", "pane.split", { direction = "auto" })
end

local shared_keys = { "alt+i", "alt+o", "alt+n" }
for index = 1, 9 do
  shared_keys[#shared_keys + 1] = "ctrl+" .. index
end
for _, direction in ipairs({ "up", "down" }) do
  shared_keys[#shared_keys + 1] = "alt+" .. direction
end
for key in pairs(hjkl) do
  shared_keys[#shared_keys + 1] = "alt+" .. key
end

-- Normal mode -----------------------------------------------------------------

bind_shared("")
rex.bind("cmd+t", "new_tab_beside") -- replaces the default, client.tab.new
rex.bind("ctrl+g", "client.mode.enter", { name = "locked" })
for mode, key in pairs(mode_keys) do
  rex.bind(key, "client.mode.enter", { name = mode })
end

-- Inside every exclusive mode -------------------------------------------------

for _, mode in ipairs(modes) do
  local prefix = mode .. "/"
  bind_shared(prefix)
  rex.bind(prefix .. "ctrl+g", "switch_mode", { name = "locked" })
  rex.bind(prefix .. "enter", "client.mode.exit_all")
  rex.bind(prefix .. "esc", "client.mode.exit_all")
  for other, key in pairs(mode_keys) do
    if other == mode then
      if mode ~= "tmux" then
        rex.bind(prefix .. key, "client.mode.exit_all")
      end
    else
      rex.bind(prefix .. key, "switch_mode", { name = other })
    end
  end
end

-- locked ----------------------------------------------------------------------
-- Only ctrl+g is Rex's; every other key bound above reaches the program.

rex.bind("locked/ctrl+g", "client.mode.exit_all")
for _, key in ipairs(shared_keys) do
  rex.bind("locked/" .. key, "pane.send_key", { key = key })
end
for key, sent in pairs(word_keys) do
  rex.bind("locked/" .. key, "pane.send_key", { key = sent })
end
for _, key in pairs(mode_keys) do
  rex.bind("locked/" .. key, "pane.send_key", { key = key })
end

-- pane ------------------------------------------------------------------------

for _, direction in ipairs(directions) do
  rex.bind("pane/" .. direction, "pane.focus", { direction = direction })
end
for key, direction in pairs(hjkl) do
  rex.bind("pane/" .. key, "pane.focus", { direction = direction })
end
rex.bind("pane/p", "pane.focus_next")
rex.bind("pane/c", "then_normal", { action = "pane.rename" })
rex.bind("pane/d", "then_normal", { action = "pane.split", args = { direction = "down" } })
rex.bind("pane/r", "then_normal", { action = "pane.split", args = { direction = "right" } })
rex.bind("pane/n", "then_normal", { action = "pane.split", args = { direction = "auto" } })
rex.bind("pane/f", "then_normal", { action = "pane.zoom" })
rex.bind("pane/x", "then_normal", { action = "pane.close" })

-- tab -------------------------------------------------------------------------

rex.bind("tab/left", "client.tab.previous")
rex.bind("tab/up", "client.tab.previous")
rex.bind("tab/h", "client.tab.previous")
rex.bind("tab/k", "client.tab.previous")
rex.bind("tab/down", "client.tab.next")
rex.bind("tab/right", "client.tab.next")
rex.bind("tab/j", "client.tab.next")
rex.bind("tab/l", "client.tab.next")
for index = 1, 9 do
  rex.bind("tab/" .. index, "then_normal", { action = "client.tab.goto", args = { index = index } })
end
rex.bind("tab/b", "then_normal", { action = "pane.move_to_new_tab" })
rex.bind("tab/n", "then_normal", { action = "new_tab_beside" })
rex.bind("tab/r", "then_normal", { action = "client.tab.rename" })
rex.bind("tab/x", "then_normal", { action = "client.tab.close" })

-- resize ----------------------------------------------------------------------

for _, direction in ipairs(directions) do
  rex.bind("resize/" .. direction, "pane.resize", { direction = direction })
end
for key, direction in pairs(hjkl) do
  rex.bind("resize/" .. key, "pane.resize", { direction = direction })
end

-- move ------------------------------------------------------------------------

for _, direction in ipairs(directions) do
  rex.bind("move/" .. direction, "pane.move", { direction = direction })
end
for key, direction in pairs(hjkl) do
  rex.bind("move/" .. key, "pane.move", { direction = direction })
end

-- tmux ------------------------------------------------------------------------

for _, direction in ipairs(directions) do
  rex.bind("tmux/" .. direction, "then_normal", { action = "pane.focus", args = { direction = direction } })
end
for key, direction in pairs(hjkl) do
  rex.bind("tmux/" .. key, "then_normal", { action = "pane.focus", args = { direction = direction } })
end
rex.bind("tmux/shift+'", "then_normal", { action = "pane.split", args = { direction = "down" } })
rex.bind("tmux/shift+5", "then_normal", { action = "pane.split", args = { direction = "right" } })
rex.bind("tmux/,", "then_normal", { action = "client.tab.rename" })
rex.bind("tmux/ctrl+b", "then_normal", { action = "pane.send_key", args = { key = "ctrl+b" } })
rex.bind("tmux/c", "then_normal", { action = "new_tab_beside" })
rex.bind("tmux/n", "then_normal", { action = "client.tab.next" })
rex.bind("tmux/p", "then_normal", { action = "client.tab.previous" })
rex.bind("tmux/o", "pane.focus_next")
rex.bind("tmux/z", "then_normal", { action = "pane.zoom" })
rex.bind("tmux/x", "then_normal", { action = "pane.close" })
