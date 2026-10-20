
#!/usr/bin/env bash

set -euo pipefail

# =========================================
# Winter Iris Dotfiles Installer
# CachyOS / Arch Linux
# =========================================

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.local/state/dotfiles-backup/$(date +%Y%m%d-%H%M%S)-$$"

# 支持预览安装，不修改文件
DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
elif [[ $# -gt 0 ]]; then
    echo "用法: $0 [--dry-run]"
    exit 1
fi

# 需要恢复的配置
CONFIGS=(
    hypr
    quickshell
    illogical-impulse
    nvim
    kitty
    fish
    starship.toml
)

echo "================================="
echo "    Winter Iris Dotfiles 🌸"
echo "================================="
echo "仓库目录: $REPO_DIR"
echo "安装目录: $CONFIG_DIR"
echo

if ! command -v rsync >/dev/null 2>&1; then
    echo "缺少 rsync，请先安装："
    echo "  sudo pacman -S --needed rsync"
    exit 1
fi

install_config() {
    local name="$1"
    local src="$REPO_DIR/$name"
    local dst="$CONFIG_DIR/$name"

    if [[ ! -e "$src" && ! -L "$src" ]]; then
        echo "[SKIP] $name (仓库中不存在)"
        return
    fi

    # 允许仓库本身位于 ~/.config
    if [[ "$REPO_DIR" == "$CONFIG_DIR" ]]; then
        echo "[SKIP] $name (已经位于目标目录)"
        return
    fi

    echo "[INSTALL] $name"

    local args=(-av --backup --backup-dir="$BACKUP_DIR")

    if [[ "$DRY_RUN" == true ]]; then
        args+=(--dry-run)
    fi

    if [[ -d "$src" ]]; then
        if [[ "$DRY_RUN" == false ]]; then
            mkdir -p "$dst" "$BACKUP_DIR"
        fi

        rsync "${args[@]}" "$src/" "$dst/"
    else
        if [[ "$DRY_RUN" == false ]]; then
            mkdir -p "$(dirname "$dst")" "$BACKUP_DIR"
        fi

        rsync "${args[@]}" "$src" "$dst"
    fi
}

echo "正在恢复配置..."
echo

for config in "${CONFIGS[@]}"; do
    install_config "$config"
done

echo
echo "================================="

if [[ "$DRY_RUN" == true ]]; then
    echo "预览完成，没有修改文件。"
else
    echo "配置安装完成！"
    echo "被覆盖文件的备份目录："
    echo "$BACKUP_DIR"
fi

echo "================================="
echo

echo "依赖检测："

for cmd in hyprctl qs nvim kitty fish starship matugen ffmpeg mpvpaper jq; do
    if command -v "$cmd" >/dev/null 2>&1; then
        printf "  [OK] %s\n" "$cmd"
    else
        printf "  [MISSING] %s\n" "$cmd"
    fi
done

echo
echo "提示：请另外安装 end4-pC 和缺少的软件。"
echo "动态壁纸 MP4 不包含在此仓库中。"
echo "恢复视频文件后，可使用 wallpaper 命令切换。"

