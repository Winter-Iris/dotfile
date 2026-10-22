#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/end4-pC}"
PATCH_FILE="$SOURCE_DIR/settings-bridge.patch"

[[ -f "$TARGET_DIR/shell.qml" ]] || {
    echo "找不到 end4-pC: $TARGET_DIR" >&2
    exit 1
}
command -v rsync >/dev/null || { echo "缺少 rsync" >&2; exit 1; }
command -v git >/dev/null || { echo "缺少 git" >&2; exit 1; }

patch_needed=false
if git -C "$TARGET_DIR" apply --reverse --check "$PATCH_FILE" 2>/dev/null; then
    echo "[SKIP] 自定义接口已接入"
else
    git -C "$TARGET_DIR" apply --check "$PATCH_FILE"
    patch_needed=true
fi

# Copy first so Quickshell's automatic reload never sees an entry without its page.
rsync -a "$SOURCE_DIR/custom/" "$TARGET_DIR/custom/"
echo "[INSTALL] 自定义组件 → $TARGET_DIR/custom"

if [[ "$patch_needed" == true ]]; then
    git -C "$TARGET_DIR" apply "$PATCH_FILE"
    echo "[PATCH] 自定义组件接口"
fi
