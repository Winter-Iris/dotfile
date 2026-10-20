hl.bind("CTRL+SUPER+ALT+Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"), {description = "Edit user keybinds"} )

-- 缩小当前窗口列宽
hl.bind(
    "SUPER + ALT + J",
    hl.dsp.layout("colresize -0.1"),
    { description = "Scrolling: Shrink column" }
)

-- 增大当前窗口列宽
hl.bind(
    "SUPER + ALT + K",
    hl.dsp.layout("colresize +0.1"),
    { description = "Scrolling: Expand column" }
)

-- 当前窗口占满屏幕宽度
hl.bind(
    "SUPER + ALT + F",
    hl.dsp.layout("colresize 1.0"),
    { description = "Scrolling: Full width" }
)

-- 一键切换 Scrolling / Dwindle 布局
hl.bind("SUPER + SHIFT + Space", function()

    local current = hl.get_config("general.layout")

    local target
    if current == "scrolling" then
        target = "dwindle"
    else
        target = "scrolling"
    end

    hl.config({
        general = {
            layout = target
        }
    })

    hl.exec_cmd(
        "notify-send -t 1500 'Hyprland Layout' '" .. target .. "'"
    )

end, {
    description = "Layout: Toggle Scrolling / Dwindle"
})
