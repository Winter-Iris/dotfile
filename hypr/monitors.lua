-- 笔记本屏幕
hl.monitor({
    output = "eDP-1",
    mode = "2560x1600@165",
    position = "0x0",
    scale = 1,
    disabled = false
})

-- 外接显示器
hl.monitor({
    output = "HDMI-A-3",
    mode = "1920x1080@144",
    position = "2560x0",
    scale = 1,
    disabled = false
})

hl.monitor({
    output = "HDMI-A-1",
    mode = "1920x1080@144",
})
