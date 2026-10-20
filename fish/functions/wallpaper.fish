
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

    for cmd in qs jq ffmpeg realpath sha256sum
        if not type -q $cmd
            echo "缺少依赖: $cmd"
            return 1
        end
    end

    set -l file (realpath -- "$argv[1]")
    set -l cfg "$HOME/.config/illogical-impulse/config.json"
    set -l thumb_dir "$HOME/.config/hypr/custom/scripts/mpvpaper_thumbnails"

    if not test -f "$cfg"
        echo "找不到 end4-pC 配置文件"
        return 1
    end

    # 2. 图片直接用作 Banner；视频则先提取 JPG
    set -l banner "$file"

    if string match -qir '\.(mp4|mkv|webm|mov|avi)$' -- "$file"
        mkdir -p "$thumb_dir"
        or return 1

        # 根据文件路径和修改时间创建缓存键，避免同名冲突
        set -l stamp (stat -c '%Y:%s' -- "$file")
        set -l key (printf '%s|%s' "$file" "$stamp" | sha256sum | cut -c1-16)
        set banner "$thumb_dir/$key.jpg"

        if not test -s "$banner"
            echo "正在提取视频封面..."

            ffmpeg -hide_banner -loglevel error -y \
                -ss 1 \
                -i "$file" \
                -frames:v 1 \
                -q:v 2 \
                "$banner"

            if test $status -ne 0
                rm -f "$banner"
                echo "封面提取失败"
                return 1
            end
        end
    else if not string match -qir '\.(png|jpe?g|webp|bmp)$' -- "$file"
        echo "不支持的壁纸格式"
        return 1
    end

    # 3. 使用 end4-pC 官方 IPC 入口切换壁纸
    echo "正在切换壁纸..."
    qs -c end4-pC ipc call wallpapers apply "$file"
    or begin
        echo "壁纸切换失败"
        return 1
    end

    # 给 Quickshell 一点时间写入壁纸状态
    sleep 1

    # 4. 同步右侧 Banner 配置
    set -l tmp (mktemp)
    or return 1

    jq --arg img "$banner" '
        .sidebar.banner = true |
        .sidebar.bannerImage = $img
    ' "$cfg" > "$tmp"

    if test $status -ne 0
        rm -f "$tmp"
        echo "Banner 配置生成失败"
        return 1
    end

    cat "$tmp" > "$cfg"
    set -l result $status
    rm -f "$tmp"

    if test $result -ne 0
        echo "Banner 配置写入失败"
        return 1
    end

    echo "✓ 壁纸已切换"
    echo "✓ Material You 配色已请求更新"
    echo "✓ Banner 已同步: $banner"
end

