-- end4-pC / Hyprland Lua: Sakura window appearance
-- Load this module AFTER hyprland.shellOverrides.main.

hl.config({
    general = {
        border_size = 4,
        col = {
            active_border = {
                colors = {
                    "rgba(ffd1dcff)",  -- light cherry blossom
                    "rgba(ff91b6ff)",  -- sakura pink
                    "rgba(f46a9bff)",  -- rose pink
                    "rgba(d8b4f8ff)"   -- lavender
                },
                angle = 45
            },
            inactive_border = "rgba(caa5b088)"
        }
    },
    decoration = {
        rounding = 16,
        active_opacity = 0.95,
        inactive_opacity = 0.8,
        blur = {
          enabled = false,
          size = 10,
          passes = 3,
          ignore_opacity = true,
          xray = false,
          popups = false,
          vibrancy = 0.20
        }
    }
})

-- Override illogical-impulse's default global no_blur=true rule.
-- Window rules are applied in order; the last matching effect wins.
hl.window_rule({
    name = "sakura-allow-window-blur",
    match = { class = ".+" },
    no_blur = true
})

