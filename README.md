# Winter Iris Dotfiles

面向 CachyOS / Arch Linux 的个人桌面配置。安装器通过交互菜单选择配置、Quickshell 和依赖操作，不接受命令行参数。

```bash
git clone https://github.com/Winter-Iris/dotfile.git ~/dotfile
cd ~/dotfile
./install.sh
```

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
