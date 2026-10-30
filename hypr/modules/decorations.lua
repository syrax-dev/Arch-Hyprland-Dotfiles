-- Window decorations

hl.config({
    decoration = {
        rounding = 16,

        active_opacity = 1.0,
        inactive_opacity = 1.0,
        fullscreen_opacity = 1.0,

        dim_inactive = false,
        dim_strength = 0.05,
        dim_special = 0.5,

        shadow = {
            enabled = false,
            range = 20,
            render_power = 3,
            color = "rgba(000000aa)",
            offset = "0 0",
            scale = 1.0,
        },

        blur = {
            enabled = true,
            size = 8,
            passes = 3,
            new_optimizations = true,
            xray = true,
            ignore_opacity = true,
            noise = 0.02,
            contrast = 1.0,
            brightness = 1.0,
            vibrancy = 0.1696,
            vibrancy_darkness = 0.0,
            special = false,
            popups = true,
            popups_ignorealpha = 0.2,
        },
    }
})
