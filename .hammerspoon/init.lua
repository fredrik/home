local desktopVisible = true

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "D", function()
  desktopVisible = not desktopVisible
  local val = desktopVisible and "true" or "false"
  hs.execute("defaults write com.apple.finder CreateDesktop " .. val .. " && killall Finder")
  hs.alert.show(desktopVisible and "Desktop icons shown" or "Desktop icons hidden")
end)
