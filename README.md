# Winter Iris Dotfiles

面向 CachyOS / Arch Linux 的个人桌面配置。安装器通过交互菜单选择配置、Quickshell 和依赖操作，不接受命令行参数。

```bash
git clone https://github.com/Winter-Iris/dotfile.git ~/dotfile
cd ~/dotfile
./install.sh
```

## 上游仓库

本仓库在以下开源项目的基础上维护个人桌面与开发配置：

| 配置部分 | 上游仓库 | 本仓库中的用途 |
| --- | --- | --- |
| Illogical Impulse / Quickshell `ii` | [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland) | 提供 Hyprland 桌面环境、Quickshell `ii` 配置和相关依赖清单 |
| Quickshell `end4-pC` | [pctrade/end4-pC](https://github.com/pctrade/end4-pC) | 提供当前使用的 `end4-pC` 桌面 Shell 配置 |
| Neovim 基础配置 | [NvChad/NvChad](https://github.com/NvChad/NvChad) | 作为 Neovim 配置框架，本仓库在其上维护插件和个人设置 |
| Neovim 插件管理器 | [folke/lazy.nvim](https://github.com/folke/lazy.nvim) | 引导并安装 Neovim 插件 |
| Kitty 搜索 kitten | [trygveaa/kitty-kitten-search](https://github.com/trygveaa/kitty-kitten-search) | `kitty/search.py` 的上游来源 |
| 显示器配置生成器 | [nwg-piotr/nwg-displays](https://github.com/nwg-piotr/nwg-displays) | 生成 `hypr/monitors.conf` 和 `hypr/workspaces.conf` |

安装时不会自动跟随上游分支。Quickshell 上游的精确提交以 [`dotfiles-meta/config.lock`](dotfiles-meta/config.lock) 为准，NvChad、lazy.nvim 及其他 Neovim 插件的精确提交以 [`nvim/lazy-lock.json`](nvim/lazy-lock.json) 为准。上游更新应先更新锁文件并在隔离环境中验证，再提交到本仓库。

## 配置组成

本 dotfiles 由以下部分组成：

| 分类 | 配置 |
| --- | --- |
| 桌面与窗口管理 | Hyprland、Hyprlock、Quickshell `ii`、Quickshell `end4-pC`、Fuzzel、Wlogout |
| 主题与外观 | Illogical Impulse、Matugen、Kvantum、GTK 3/4、KDE 全局主题、XSettings、Fontconfig |
| Shell 与终端 | Fish、Zsh 配置片段、Kitty、Starship |
| 编辑器与开发 | Neovim / NvChad 及其锁定插件 |
| 系统信息与可视化 | Fastfetch、btop、Cava |
| 媒体与文件关联 | mpv、MIME 默认应用配置 |
| 个人资源 | 头像、默认壁纸及其在 Quickshell 和 Hyprlock 中的引用 |
| 安装与版本锁定 | 交互式 `install.sh`、配置源码锁、软件包版本锁和锁文件更新脚本 |

一键安装的本地配置清单以 [`dotfiles-meta/config.lock`](dotfiles-meta/config.lock) 中的 `local` 条目为准；两套 Quickshell 配置由同一文件中的 `git` 条目从固定提交获取。仓库目录中未列入该锁文件的应用运行数据和机器专属配置不属于可复现安装范围。

## Fish 壁纸命令

Fish 中提供了 `wallpaper` 命令，可同时切换静态图片和动态壁纸：

```fish
# 静态壁纸
wallpaper ~/Pictures/wallpaper.jpg

# 动态壁纸
wallpaper ~/Videos/wallpaper.mp4

# 路径包含空格时需要引号
wallpaper "$HOME/Videos/Live Wallpapers/miku.webm"
```

支持的图片格式为 PNG、JPG、JPEG、WebP 和 BMP；支持的视频格式为 MP4、MKV、WebM、MOV 和 AVI。

切换视频时，命令会让 Quickshell 应用视频并更新主题，同时通过 FFmpeg 提取封面用于侧栏 Banner。原始视频路径会保存在 `~/.config/illogical-impulse/config.json` 中，下次登录时由 Hyprland 自动恢复 `mpvpaper`。

该命令需要 `qs`、`jq`、`ffmpeg`、`realpath` 和 `sha256sum`，并要求 `end4-pC` Quickshell 正在运行。安装器的依赖锁已包含相关软件。

## 可复现范围

- `dotfiles-meta/config.lock` 列出本仓库配置，并用完整 Git 提交哈希固定两套 Quickshell 上游配置。
- `dotfiles-meta/packages.lock` 固定配置直接使用的软件及 Quickshell 的直接依赖版本。安装前会先核对软件源候选版本；只要有一个版本不同，就会在调用 `sudo pacman` 前停止。定制 Quickshell 包从同一个锁定的上游提交构建。
- 被覆盖的配置会备份到 `~/.local/state/dotfiles/backups/`。
- 仓库头像和默认壁纸会安装到 `~/.config/dotfiles-assets/`，并自动写入 Quickshell、预设、侧栏 Banner 和 Hyprlock 配置。
- 私人壁纸和动态壁纸媒体不进入仓库。安装器会把配置中的原作者主目录替换为当前 `$HOME`，但媒体文件仍需自行放置。

Arch/CachyOS 是滚动发行版。锁文件用于固定这一套 dotfiles 已验证的兼容版本，不等同于完整系统镜像；软件源不再提供锁定版本时，安装器会拒绝偷偷改装新版。

## 更新

先正常更新系统并验证桌面功能，再运行：

```bash
./scripts/update-lock.sh
git diff -- dotfiles-meta/packages.lock
```

Quickshell 更新需要手工修改 `dotfiles-meta/config.lock` 中的完整提交哈希，经过隔离环境验证后再提交。
