# end4-pC 自定义层

此目录是自定义代码的唯一源文件位置。不要直接编辑安装目录 `quickshell/end4-pC/custom/`，以免重新安装时丢失修改。

- `custom/components/`：新增的小组件。
- `custom/overrides/`：原组件的样式覆盖；通过小型加载接口接入，不复制整份上游文件。当前包含通知中心无通知样式。
- `custom/assets/`：自定义组件使用的图片，包含通知空状态贴图。
- `custom/settings/`：「自定义组件」设置页。
- `custom/CustomConfig.qml`：独立设置，写入 `~/.config/illogical-impulse/custom-components.json`。
- `settings-bridge.patch`：Settings 入口和通知空状态切换接口的最小补丁。

主安装器安装配置时，如目标目录已有 end4-pC（或本次选择下载），会自动安装此自定义层。单独安装或更新上游 end4-pC 后，可从仓库根目录运行 `./dotfiles-custom/end4-pC/install-custom.sh`。脚本可重复运行，补丁不兼容新版上游时会停止并要求人工调整；不会自动改写补丁。

Settings → 自定义组件 → 通知中心的「自定义无通知样式」默认开启，关闭即可恢复上游样式。设置保存在 `~/.config/illogical-impulse/custom-components.json`，这是运行时数据，不需要提交。新增自定义选项时，先在 `CustomConfig.qml` 声明默认值，再在 `CustomSettingsPage.qml` 增加控件。示例样式开关目前仅影响预览。
