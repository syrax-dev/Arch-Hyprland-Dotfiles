-- General window and workspace settings
local colors = require("colors.catppuccin")

hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 3,
        border_size = 1,

        col = {
            active_border = colors.lavender,
            inactive_border = colors.lavender,
        },

        layout = "dwindle",
        allow_tearing = false,

        resize_on_border = true,
        extend_border_grab_area = 15,
        hover_icon_on_border = true,

        no_focus_fallback = false,
    }
})
