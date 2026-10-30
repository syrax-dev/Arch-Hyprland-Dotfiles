-- Window rules

local float_classes = {
    "pavucontrol",
    "blueman-manager",
    "nm-connection-editor",
    "nwg-look",
    "qt5ct",
    "qt6ct",
    "gsimplecal",
}

for _, cls in ipairs(float_classes) do
    hl.window_rule({ match = { class = cls }, float = true })
end

hl.window_rule({ match = { title = "File Operation Progress" }, float = true })

-- Picture-in-Picture
hl.window_rule({
    name  = "pip",
    match = { title = "Picture-in-Picture" },
    float = true,
    pin   = true,
    move  = "75% 75%",
    size  = "24% 24%",
})

-- Firefox sharing indicator
hl.window_rule({
    match     = { title = "Firefox — Sharing Indicator" },
    workspace = "special:silent",
})
hl.window_rule({
    match     = { title = ".*is sharing (your screen|a window)\\." },
    workspace = "special:silent",
})

-- Workspace assignments
local ws_classes = {
    ["1"] = { "antigravity", "com\\.anthropic\\.Claude", "LM-Studio" },
    ["2"] = { "md\\.obsidian\\.Obsidian" },
    ["3"] = { "Postman", "requestly-api-client" },
    ["4"] = { "kitty" },
    ["5"] = { "antigravity-ide", "code", "codium", "dev\\.zed\\.Zed" },
    ["6"] = { "zen", "firefox" },
    ["7"] = { "discord" },
    ["8"] = { "Spotify" },
    ["9"] = { "steam" },
}

for ws, classes in pairs(ws_classes) do
    for _, cls in ipairs(classes) do
        hl.window_rule({
            match     = { class = cls },
            workspace = ws,
        })
    end
end

-- Size rules
hl.window_rule({
    name   = "size",
    match  = { class = "pavucontrol" },
    size   = "800 600",
    center = true,
})

-- Maximize specific windows
hl.window_rule({
    match      = { class = "libreoffice" },
    fullscreen = true,
})

-- No blur for certain windows
hl.window_rule({
    match   = { class = "firefox" },
    no_blur = true,
})

-- Idle inhibit
hl.window_rule({
    match        = { class = "mpv" },
    idle_inhibit = "focus",
})
hl.window_rule({
    match        = { class = "firefox" },
    idle_inhibit = "fullscreen",
})

-- XWayland apps (force scaling)
hl.window_rule({
    match    = { xwayland = true },
    rounding = 0,
})

-- Spotify – sane floating size
hl.window_rule({
    name      = "Spotify",
    match     = { class = "Spotify" },
    size      = "70% 85%",
    center    = true,
    rounding  = 16,
    opacity   = 0.75,
})

-- Suppress maximize events and fix xwayland drags
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})
