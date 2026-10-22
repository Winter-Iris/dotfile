#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
BACKUP_DIR="$STATE_DIR/backups/$(date +%Y%m%d-%H%M%S)-$$"
CONFIG_LOCK="$REPO_DIR/dotfiles-meta/config.lock"
PACKAGE_LOCK="$REPO_DIR/dotfiles-meta/packages.lock"
SOURCE_HOME="/home/irisyuki"
SOURCE_CHECKOUT=""
WORK_DIRS=()

cleanup() {
    local dir
    for dir in "${WORK_DIRS[@]}"; do
        [[ ! -d "$dir" ]] || rm -rf -- "$dir"
    done
}
trap cleanup EXIT

ask_yes_no() {
    local prompt="$1" default="$2" answer
    local hint="[y/N]"
    [[ "$default" == "yes" ]] && hint="[Y/n]"

    while true; do
        read -r -p "$prompt $hint " answer || exit 1
        answer="${answer:-$default}"
        case "${answer,,}" in
            y|yes) return 0 ;;
            n|no) return 1 ;;
            *) echo "请输入 y 或 n。" ;;
        esac
    done
}

choose_dependency_action() {
    local answer
    echo "依赖处理："
    echo "  1) 跳过（默认）"
    echo "  2) 仅核对已安装版本"
    echo "  3) 安装锁定版本"
    while true; do
        read -r -p "请选择 [1-3]: " answer || exit 1
        case "${answer:-1}" in
            1) DEP_ACTION="skip"; return ;;
            2) DEP_ACTION="verify"; return ;;
            3) DEP_ACTION="install"; return ;;
            *) echo "请输入 1、2 或 3。" ;;
        esac
    done
}

echo "================================="
echo "    Winter Iris Dotfiles 🌸"
echo "================================="
echo "仓库目录: $REPO_DIR"
echo "安装目录: $CONFIG_DIR"
echo

INSTALL_CONFIG=false
INSTALL_UPSTREAM=false
if ask_yes_no "安装仓库内的配置？" yes; then
    INSTALL_CONFIG=true
    if ask_yes_no "下载并安装锁定提交的 Quickshell 配置？" yes; then
        INSTALL_UPSTREAM=true
    fi
fi
choose_dependency_action

echo
echo "本次操作："
echo "  仓库配置: $INSTALL_CONFIG"
echo "  Quickshell: $INSTALL_UPSTREAM"
echo "  依赖处理: $DEP_ACTION"
echo
if ! ask_yes_no "继续？" yes; then
    echo "已取消。"
    exit 0
fi

install_tree() {
    local src="$1" dst="$2" label="$3"
    if [[ ! -e "$src" ]]; then
        echo "[ERROR] 清单中的源不存在: $label ($src)" >&2
        return 1
    fi
    if [[ "$src" == "$dst" ]]; then
        echo "[SKIP] $label 已在目标位置"
        return
    fi

    echo "[INSTALL] $label"
    mkdir -p "$dst" "$BACKUP_DIR"
    rsync -a --exclude=.git --backup --backup-dir="$BACKUP_DIR" "$src/" "$dst/"
}

install_file() {
    local src="$1" dst="$2" label="$3"
    if [[ ! -f "$src" ]]; then
        echo "[ERROR] 清单中的源不存在: $label ($src)" >&2
        return 1
    fi
    if [[ "$src" == "$dst" ]]; then
        echo "[SKIP] $label 已在目标位置"
        return
    fi

    echo "[INSTALL] $label"
    mkdir -p "$(dirname "$dst")" "$BACKUP_DIR"
    rsync -a --backup --backup-dir="$BACKUP_DIR" "$src" "$dst"
}

install_local_configs() {
    command -v rsync >/dev/null 2>&1 || {
        echo "缺少 rsync；请先选择安装依赖，或手动安装 rsync。" >&2
        return 1
    }

    while IFS=$'\t' read -r kind path rest; do
        [[ -z "$kind" || "$kind" == \#* || "$kind" != "local" ]] && continue
        if [[ -d "$REPO_DIR/$path" ]]; then
            install_tree "$REPO_DIR/$path" "$CONFIG_DIR/$path" "$path"
        else
            install_file "$REPO_DIR/$path" "$CONFIG_DIR/$path" "$path"
        fi
    done < "$CONFIG_LOCK"
}

install_upstream_configs() {
    command -v git >/dev/null 2>&1 || {
        echo "缺少 git，无法获取锁定的 Quickshell 配置。" >&2
        return 1
    }
    command -v rsync >/dev/null 2>&1 || {
        echo "缺少 rsync，无法安装 Quickshell 配置。" >&2
        return 1
    }

    local work_dir
    work_dir="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-install.XXXXXX")"
    WORK_DIRS+=("$work_dir")
    while IFS=$'\t' read -r kind name url revision subdir target; do
        [[ -z "$kind" || "$kind" == \#* || "$kind" != "git" ]] && continue
        local checkout="$work_dir/$name"
        echo "[FETCH] $name @ ${revision:0:12}"
        git init --quiet "$checkout"
        git -C "$checkout" remote add origin "$url"
        git -C "$checkout" fetch --quiet --depth 1 origin "$revision"
        git -C "$checkout" checkout --quiet --detach FETCH_HEAD
        git -C "$checkout" submodule update --init --recursive --depth 1 --quiet

        local patch_file="$REPO_DIR/dotfiles-meta/patches/$name.patch"
        if [[ -f "$patch_file" ]]; then
            echo "[PATCH] $name"
            git -C "$checkout" apply --check "$patch_file"
            git -C "$checkout" apply "$patch_file"
        fi

        install_tree "$checkout/$subdir" "$CONFIG_DIR/$target" "$target"
    done < "$CONFIG_LOCK"
}

rewrite_home_paths() {
    local files=(
        "$CONFIG_DIR/illogical-impulse/config.json"
        "$CONFIG_DIR/illogical-impulse/presets/mypresets.json"
        "$CONFIG_DIR/hypr/hyprlock/colors.conf"
        "$CONFIG_DIR/hypr/custom/scripts/__restore_video_wallpaper.sh"
    )
    local file
    for file in "${files[@]}"; do
        [[ -f "$file" ]] || continue
        sed -i "s|$SOURCE_HOME|$HOME|g" "$file"
    done
}

verify_installed_dependencies() {
    local failed=0 source package expected actual
    while IFS=$'\t' read -r source package expected; do
        [[ -z "$source" || "$source" == \#* ]] && continue
        actual="$(pacman -Q "$package" 2>/dev/null | cut -d' ' -f2- || true)"
        if [[ "$actual" == "$expected" ]]; then
            printf '  [OK] %s %s\n' "$package" "$actual"
        elif [[ -z "$actual" ]]; then
            printf '  [MISSING] %s (需要 %s)\n' "$package" "$expected"
            failed=1
        else
            printf '  [MISMATCH] %s: 已安装 %s，需要 %s\n' "$package" "$actual" "$expected"
            failed=1
        fi
    done < "$PACKAGE_LOCK"
    return "$failed"
}

install_locked_dependencies() {
    [[ -r /etc/cachyos-release ]] || {
        echo "锁文件面向 CachyOS；当前系统不符合，已拒绝安装。" >&2
        return 1
    }
    command -v pacman >/dev/null 2>&1 || {
        echo "缺少 pacman。" >&2
        return 1
    }

    local source package expected candidate work_dir
    local -a repo_packages=() source_packages=()
    echo "正在预检软件源中的版本……"
    while IFS=$'\t' read -r source package expected; do
        [[ -z "$source" || "$source" == \#* ]] && continue
        case "$source" in
            repo)
                candidate="$(pacman -Si "$package" 2>/dev/null | sed -n 's/^Version         : //p' | head -n1)"
                repo_packages+=("$package")
                ;;
            source)
                if [[ -z "$SOURCE_CHECKOUT" ]]; then
                    work_dir="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-build.XXXXXX")"
                    WORK_DIRS+=("$work_dir")
                    SOURCE_CHECKOUT="$work_dir/dots-hyprland"
                    git init --quiet "$SOURCE_CHECKOUT"
                    git -C "$SOURCE_CHECKOUT" remote add origin https://github.com/end-4/dots-hyprland.git
                    git -C "$SOURCE_CHECKOUT" fetch --quiet --depth 1 origin c4f0582cbf4ad29607dbf3c20337815de8690b34
                    git -C "$SOURCE_CHECKOUT" checkout --quiet --detach FETCH_HEAD
                fi
                candidate="$(cd "$SOURCE_CHECKOUT/sdata/dist-arch/$package" && makepkg --printsrcinfo | awk '$1 == "pkgver" {v=$3} $1 == "pkgrel" {r=$3} END {print v "-" r}')"
                source_packages+=("$package")
                ;;
            *) echo "未知依赖来源: $source" >&2; return 1 ;;
        esac
        if [[ "$candidate" != "$expected" ]]; then
            echo "版本不可复现: $package，锁定 $expected，软件源提供 ${candidate:-无}" >&2
            echo "安装已在修改系统前停止。请先审查更新，再运行 scripts/update-lock.sh。" >&2
            return 1
        fi
    done < "$PACKAGE_LOCK"

    ((${#repo_packages[@]} == 0)) || sudo pacman -S --needed "${repo_packages[@]}"
    for package in "${source_packages[@]}"; do
        (cd "$SOURCE_CHECKOUT/sdata/dist-arch/$package" && makepkg -si --needed --noconfirm)
    done
    verify_installed_dependencies
}

if [[ "$DEP_ACTION" == "install" ]]; then
    install_locked_dependencies
elif [[ "$DEP_ACTION" == "verify" ]]; then
    verify_installed_dependencies || true
fi

if [[ "$INSTALL_CONFIG" == true ]]; then
    install_local_configs
    [[ "$INSTALL_UPSTREAM" == false ]] || install_upstream_configs
    rewrite_home_paths
    echo
    echo "配置安装完成。覆盖文件备份在：$BACKUP_DIR"
fi

echo "完成。"
