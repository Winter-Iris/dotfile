import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

Item {
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 4

        Item {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 150
            Layout.preferredHeight: 129
            clip: true

            Image {
                width: parent.width
                height: width
                source: Qt.resolvedUrl("../assets/notification_empty.png")
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
            }
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: "暂无通知"
            font.pixelSize: Appearance.font.pixelSize.normal
            color: Appearance.colors.colOnLayer1
            horizontalAlignment: Text.AlignHCenter
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: "好好休息一下吧~"
            font.pixelSize: Appearance.font.pixelSize.small
            color: Appearance.colors.colSubtext
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
