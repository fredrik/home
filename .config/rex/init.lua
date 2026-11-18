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
    rex.client.queue(args.action, args.args or {})
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

local function bind_shared(prefix)
  for index = 1, 9 do
    rex.bind(prefix .. "ctrl+" .. index, "client.tab.goto", { index = index })
  end
  for _, direction in ipairs(directions) do
    rex.bind(prefix .. "alt+" .. direction, "pane.focus", { direction = direction })
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
for _, direction in ipairs(directions) do
  shared_keys[#shared_keys + 1] = "alt+" .. direction
end
for key in pairs(hjkl) do
  shared_keys[#shared_keys + 1] = "alt+" .. key
end

-- Normal mode -----------------------------------------------------------------

bind_shared("")
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
rex.bind("tab/n", "then_normal", { action = "client.tab.new" })
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
rex.bind("tmux/c", "then_normal", { action = "client.tab.new" })
rex.bind("tmux/n", "then_normal", { action = "client.tab.next" })
rex.bind("tmux/p", "then_normal", { action = "client.tab.previous" })
rex.bind("tmux/o", "pane.focus_next")
rex.bind("tmux/z", "then_normal", { action = "pane.zoom" })
rex.bind("tmux/x", "then_normal", { action = "pane.close" })
