-- Keybindings configuration

local mainMod = "SUPER"
local terminal = "kitty"
local fileManager = "thunar"
local menu = "rofi -show drun"
local browser = "zen-browser"

--------------------------------------------------------------------------------
-- APPLICATIONS
--------------------------------------------------------------------------------
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.local/bin/wallpaper-switcher.sh"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("brave --app=https://web.whatsapp.com"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("discord"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("postman"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(os.getenv("HOME") .. "/Applications/requestly.AppImage"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("codium --ozone-platform=wayland"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("code"))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/waybar/launch.sh"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("obsidian"))
hl.bind("XF86Calculator", hl.dsp.exec_cmd("gnome-calculator"))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("antigravity"))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd(os.getenv("HOME") .. "/Applications/Antigravity\\ IDE/antigravity-ide"))

--------------------------------------------------------------------------------
-- ROFI
--------------------------------------------------------------------------------
hl.bind("CTRL + SHIFT + E", hl.dsp.exec_cmd("rofi -show emoji -modi emoji"))

--------------------------------------------------------------------------------
-- WAYBAR TOGGLE
--------------------------------------------------------------------------------
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.local/bin/toggle-waybar"))

--------------------------------------------------------------------------------
-- WINDOW MANAGEMENT
--------------------------------------------------------------------------------
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(0))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen(1))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + T", hl.dsp.window.pin())
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exit())

--------------------------------------------------------------------------------
-- GROUP MANAGEMENT
--------------------------------------------------------------------------------
hl.bind(mainMod .. " + Tab", function() hl.dispatch("changegroupactive", "f") end)
hl.bind(mainMod .. " + SHIFT + Tab", function() hl.dispatch("changegroupactive", "b") end)

--------------------------------------------------------------------------------
-- FOCUS MOVEMENT
--------------------------------------------------------------------------------
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

--------------------------------------------------------------------------------
-- MOVE WINDOWS
--------------------------------------------------------------------------------
hl.bind(mainMod .. " + SHIFT + left",  function() hl.dispatch("movewindow", "l") end)
hl.bind(mainMod .. " + SHIFT + right", function() hl.dispatch("movewindow", "r") end)
hl.bind(mainMod .. " + SHIFT + up",    function() hl.dispatch("movewindow", "u") end)
hl.bind(mainMod .. " + SHIFT + down",  function() hl.dispatch("movewindow", "d") end)

hl.bind(mainMod .. " + SHIFT + H", function() hl.dispatch("movewindow", "l") end)
hl.bind(mainMod .. " + SHIFT + L", function() hl.dispatch("movewindow", "r") end)
hl.bind(mainMod .. " + SHIFT + K", function() hl.dispatch("movewindow", "u") end)
hl.bind(mainMod .. " + SHIFT + J", function() hl.dispatch("movewindow", "d") end)

--------------------------------------------------------------------------------
-- RESIZE WINDOWS
--------------------------------------------------------------------------------
hl.bind(mainMod .. " + CTRL + left",  function() hl.dispatch("resizeactive", "-50 0") end)
hl.bind(mainMod .. " + CTRL + right", function() hl.dispatch("resizeactive", "50 0") end)
hl.bind(mainMod .. " + CTRL + up",    function() hl.dispatch("resizeactive", "0 -50") end)
hl.bind(mainMod .. " + CTRL + down",  function() hl.dispatch("resizeactive", "0 50") end)

hl.bind(mainMod .. " + CTRL + H", function() hl.dispatch("resizeactive", "-50 0") end)
hl.bind(mainMod .. " + CTRL + L", function() hl.dispatch("resizeactive", "50 0") end)
hl.bind(mainMod .. " + CTRL + K", function() hl.dispatch("resizeactive", "0 -50") end)
hl.bind(mainMod .. " + CTRL + J", function() hl.dispatch("resizeactive", "0 50") end)

--------------------------------------------------------------------------------
-- WORKSPACES
--------------------------------------------------------------------------------
for i = 1, 10 do
    local key = i % 10 -- 10 maps to 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. key,      function() hl.dispatch("movetoworkspacesilent", tostring(i)) end)
end

--------------------------------------------------------------------------------
-- SPECIAL WORKSPACE
--------------------------------------------------------------------------------
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

--------------------------------------------------------------------------------
-- WORKSPACE NAVIGATION
--------------------------------------------------------------------------------
hl.bind(mainMod .. " + mouse_down",   hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",     hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + bracketleft",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + bracketright", hl.dsp.focus({ workspace = "e+1" }))

--------------------------------------------------------------------------------
-- MOUSE
--------------------------------------------------------------------------------
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--------------------------------------------------------------------------------
-- SYSTEM
--------------------------------------------------------------------------------
hl.bind(mainMod .. " + SHIFT + Escape", hl.dsp.exec_cmd("systemctl suspend"))
hl.bind("CTRL + ALT + Delete",          hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/rofi/powermenu.sh"))

--------------------------------------------------------------------------------
-- SCREENSHOTS
--------------------------------------------------------------------------------
hl.bind("SHIFT + Print",          hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))
hl.bind("Print",                  hl.dsp.exec_cmd([[grim - | wl-copy]]))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png]]))
hl.bind(mainMod .. " + Print",         hl.dsp.exec_cmd([[grim ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png]]))

--------------------------------------------------------------------------------
-- AUDIO / SWAYOSD
--------------------------------------------------------------------------------
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume +2"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume -2"),   { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),  { locked = true })

hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("swayosd-client --playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("swayosd-client --playerctl pause"),      { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("swayosd-client --playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("swayosd-client --playerctl prev"),       { locked = true })

--------------------------------------------------------------------------------
-- BRIGHTNESS / SWAYOSD
--------------------------------------------------------------------------------
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"), { locked = true, repeating = true })

--------------------------------------------------------------------------------
-- LOCK KEY OSD
--------------------------------------------------------------------------------
hl.bind("Caps_Lock", hl.dsp.exec_cmd("sh -c 'sleep 0.1 && swayosd-client --caps-lock-led input5::capslock'"), { release = true })
hl.bind("Num_Lock",  hl.dsp.exec_cmd("swayosd-client --num-lock"), { release = true })

--------------------------------------------------------------------------------
-- CLIPBOARD & LOCK SCREEN
--------------------------------------------------------------------------------
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/rofi/clipboard.sh"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
