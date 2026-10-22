这里放原组件的自定义样式实现。需要替换原组件时，在 `settings-bridge.patch` 或新的小补丁中增加可回退的加载接口；不要直接复制并长期维护整份上游组件。

`NotificationEmptyState.qml` 是通知中心无通知时的自定义贴图和文案。贴图保存在 `../assets/notification_empty.png`；可在 Settings → 自定义组件 → 通知中心关闭，并切回上游默认样式。
