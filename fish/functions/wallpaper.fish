
function wallpaper --description "end4-pC 壁纸、Material You 与 Banner 联动"
    if test (count $argv) -ne 1
        echo "用法: wallpaper <图片或视频路径>"
        return 1
    end

    # 1. 检查文件和依赖
    if not test -f "$argv[1]"
        echo "找不到壁纸: $argv[1]"
        return 1
    end

    for cmd in realpath
        if not type -q $cmd
            echo "缺少依赖: $cmd"
            return 1
        end
    end

    set -l file (realpath -- "$argv[1]")
    set -l switcher "$HOME/.config/quickshell/end4-pC/scripts/colors/switchwall.sh"

    if not test -x "$switcher"
        echo "找不到 end4-pC 壁纸切换脚本"
        return 1
    end

    if not string match -qir '\.(png|jpe?g|webp|bmp|mp4|mkv|webm|mov|avi)$' -- "$file"
        echo "不支持的壁纸格式"
        return 1
    end

    # 使用统一入口并等待切换完成，避免和选择器并发写配置。
    echo "正在切换壁纸..."
    "$switcher" --image "$file"
    or begin
        echo "壁纸切换失败"
        return 1
    end

    echo "✓ 壁纸已切换"
    echo "✓ Material You 配色与 Banner 已同步"
end

