-- Input device configuration

hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",

        follow_mouse = 1,
        float_switch_override_focus = 2,

        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            tap_to_click = true,
            drag_lock = false,
            clickfinger_behavior = false,
            middle_button_emulation = true,
            scroll_factor = 1.0,
        },

        sensitivity = 0,
        accel_profile = "adaptive",
        force_no_accel = false,

        numlock_by_default = true,
        repeat_rate = 25,
        repeat_delay = 600,
    }
})
