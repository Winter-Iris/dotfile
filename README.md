# Winter Iris Dotfiles

CachyOS / Arch Linux 的 Hyprland 桌面与开发配置。提供交互式安装器，并锁定外部源码和直接依赖版本。

## 预览

[![Hyprland 桌面概览](dotfiles-assets/gallery/desktop1.png)](dotfiles-assets/gallery/desktop1.png)

<table>
  <tr>
    <td width="50%">
      <a href="dotfiles-assets/gallery/desktop2.png">
        <img src="dotfiles-assets/gallery/desktop2.png" alt="Quickshell 智能助手与控制中心侧栏">
      </a>
    </td>
    <td width="50%">
      <a href="dotfiles-assets/gallery/nvim.png">
        <img src="dotfiles-assets/gallery/nvim.png" alt="Kitty 中的 Neovim 开发环境">
      </a>
    </td>
  </tr>
  <tr>
    <td align="center">Quickshell 侧栏</td>
    <td align="center">Neovim 开发环境</td>
  </tr>
</table>

## 组成

| 用途 | 组件 |
| --- | --- |
| 桌面 | Hyprland、Hyprlock、Quickshell `end4-pC` / `ii`、Fuzzel、Wlogout |
| 外观 | Matugen、Illogical Impulse、GTK 3/4、Kvantum、KDE Colors、Fontconfig |
| 终端 | Fish、Kitty、Starship、Zsh 配置片段 |
| 开发 | Neovim / NvChad |
| 工具 | btop、Cava、Fastfetch、mpv |
| 资源 | 头像、默认壁纸、MIME 文件关联 |

安装清单见 [`dotfiles-meta/config.lock`](dotfiles-meta/config.lock)，软件包版本见 [`dotfiles-meta/packages.lock`](dotfiles-meta/packages.lock)。

## 安装

```bash
git clone https://github.com/Winter-Iris/dotfile.git ~/dotfile
cd ~/dotfile
./install.sh
```

安装器启动后可选择：

- 安装仓库配置
- 下载固定版本的 Quickshell 配置
- 跳过、核对或安装依赖

安装器不接受命令行参数。覆盖前的配置保存在 `~/.local/state/dotfiles/backups/`。依赖自动安装仅支持 CachyOS。

## 壁纸命令

Fish 中的 `wallpaper` 命令支持图片和视频：

```fish
wallpaper ~/Pictures/wallpaper.jpg
wallpaper ~/Videos/wallpaper.mp4
wallpaper "$HOME/Videos/Live Wallpapers/miku.webm"
```

图片支持 PNG、JPG、JPEG、WebP 和 BMP；视频支持 MP4、MKV、WebM、MOV 和 AVI。

视频会交给 Quickshell 和 `mpvpaper` 播放，并由 FFmpeg 生成侧栏封面。此命令需要正在运行的 `end4-pC`，相关依赖已写入软件包锁文件。

## 上游

| 项目 | 用途 |
| --- | --- |
| [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland) | Illogical Impulse、Quickshell `ii` 和构建配置 |
| [pctrade/end4-pC](https://github.com/pctrade/end4-pC) | Quickshell `end4-pC` |
| [NvChad/NvChad](https://github.com/NvChad/NvChad) | Neovim 配置框架 |
| [folke/lazy.nvim](https://github.com/folke/lazy.nvim) | Neovim 插件管理 |
| [trygveaa/kitty-kitten-search](https://github.com/trygveaa/kitty-kitten-search) | Kitty 搜索 kitten |
| [nwg-piotr/nwg-displays](https://github.com/nwg-piotr/nwg-displays) | 显示器和工作区配置生成器 |

Quickshell 的提交由 [`config.lock`](dotfiles-meta/config.lock) 固定；Neovim 插件的提交由 [`lazy-lock.json`](nvim/lazy-lock.json) 固定。安装时不会自动跟随上游分支。

## 可复现范围

- 本地配置和 Quickshell 源码使用完整 Git 提交哈希固定。
- 直接依赖精确到软件包版本；软件源版本不一致时，安装器会在修改系统前停止。
- 仓库包含默认头像和壁纸，并在安装时将个人主目录路径替换为当前 `$HOME`。
- 私人媒体、应用运行数据和机器专属配置不在安装清单中。

这套锁文件用于复现桌面与开发环境，不包含完整操作系统状态。滚动更新后若锁定版本已从软件源移除，需要先更新并重新验证锁文件。

## 更新

更新系统并确认桌面工作正常后，刷新软件包锁：

```bash
./scripts/update-lock.sh
git diff -- dotfiles-meta/packages.lock
```

Quickshell 更新需要修改 [`config.lock`](dotfiles-meta/config.lock) 中的提交哈希，并在隔离环境中验证。
