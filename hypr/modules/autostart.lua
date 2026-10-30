-- Autostart processes

local autostart_commands = {
    -- Environment & DBus
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
    "gnome-keyring-daemon --start --components=secrets",
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",

    -- Clipboard
    "wl-paste --type text --watch cliphist store",
    "wl-paste --type image --watch cliphist store",

    -- Wallpaper
    "swww-daemon",

    -- Tray & Bar
    "nm-applet",
    "blueman-applet",
    "swaync",
    "waybar",

    -- Idle
    "hypridle",

    -- RGB
    "openrgb --startminimized --profile " .. os.getenv("HOME") .. "/.config/OpenRGB/Catppucin.orp",

    -- Cloud & Tools
    "dropbox",
    "swayosd-server",
    "pkexec swayosd-libinput-backend",


    -- OmniRoute
    "omniroute",
}

hl.on("hyprland.start", function()
    for _, cmd in ipairs(autostart_commands) do
        hl.exec_cmd(cmd)
    end
end)
