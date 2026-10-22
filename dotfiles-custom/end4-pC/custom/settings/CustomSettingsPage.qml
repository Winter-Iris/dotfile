import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    id: page
    forceWidth: true
    baseWidth: 700
    readonly property bool exampleStyle: configLoader.item?.options.appearance.exampleStyle ?? false
    readonly property bool customNotificationEmptyState: configLoader.item?.options?.customNotificationEmptyState ?? true

    Loader {
        id: configLoader
        source: Qt.resolvedUrl("../CustomConfig.qml")
        visible: false
    }

    ContentSection {
        Layout.fillWidth: true
        title: "自定义组件"
        icon: "widgets"
        collapsible: false

        GroupedList {
            ConfigSwitch {
                buttonIcon: "palette"
                text: "示例样式预览"
                checked: page.exampleStyle
                onClicked: {
                    const appearance = configLoader.item?.options.appearance;
                    if (appearance) appearance.exampleStyle = !appearance.exampleStyle;
                }
            }
        }

        Loader {
            id: previewLoader
            Layout.fillWidth: true
            Layout.preferredHeight: 110
            source: Qt.resolvedUrl("../components/ExampleWidget.qml")
        }

        Binding {
            target: previewLoader.item
            property: "exampleStyle"
            value: page.exampleStyle
            when: previewLoader.item !== null
        }

        StyledText {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: "此开关目前只改变上方示例组件。以后为原组件增加样式接口时，再由接口读取这个设置。"
            color: Appearance.colors.colSubtext
        }
    }


    ContentSection {
        Layout.fillWidth: true
        title: "通知中心"
        icon: "notifications"
        collapsible: false

        GroupedList {
            ConfigSwitch {
                buttonIcon: "image"
                text: "自定义无通知样式"
                checked: page.customNotificationEmptyState
                onClicked: {
                    const options = configLoader.item?.options;
                    if (options) options.customNotificationEmptyState = !page.customNotificationEmptyState;
                }
            }
        }

        StyledText {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: "启用时显示自定义贴图和文案；关闭后恢复上游默认样式。"
            color: Appearance.colors.colSubtext
        }
    }
}
