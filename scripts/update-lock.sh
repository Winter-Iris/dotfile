#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCK_FILE="$REPO_DIR/dotfiles-meta/packages.lock"
TEMP_FILE="$(mktemp "${TMPDIR:-/tmp}/packages.lock.XXXXXX")"
trap 'rm -f -- "$TEMP_FILE"' EXIT

echo "此操作会把依赖锁更新为当前已安装版本。"
echo "更新前应先验证桌面、Quickshell、Neovim 和终端配置。"
read -r -p "继续？[y/N] " answer
[[ "${answer,,}" == "y" || "${answer,,}" == "yes" ]] || exit 0

while IFS=$'\t' read -r source package old_version; do
    if [[ -z "$source" || "$source" == \#* ]]; then
        printf '%s\n' "$source${package:+$'\t'$package}${old_version:+$'\t'$old_version}" >> "$TEMP_FILE"
        continue
    fi
    version="$(pacman -Q "$package" 2>/dev/null | cut -d' ' -f2- || true)"
    if [[ -z "$version" ]]; then
        echo "缺少 $package，锁文件未修改。" >&2
        exit 1
    fi
    printf '%s\t%s\t%s\n' "$source" "$package" "$version" >> "$TEMP_FILE"
done < "$LOCK_FILE"

mv "$TEMP_FILE" "$LOCK_FILE"
trap - EXIT
echo "已更新 $LOCK_FILE；请检查 git diff 后再提交。"
