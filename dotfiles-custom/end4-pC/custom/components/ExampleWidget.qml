import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root
    property bool exampleStyle: false

    implicitHeight: 110
    radius: exampleStyle ? 28 : 12
    color: exampleStyle ? Appearance.colors.colPrimaryContainer : Appearance.colors.colLayer1
    border.width: exampleStyle ? 2 : 0
    border.color: Appearance.colors.colPrimary

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 14

        MaterialSymbol {
            text: "widgets"
            iconSize: 32
            color: root.exampleStyle ? Appearance.colors.colOnPrimaryContainer : Appearance.colors.colOnLayer1
        }
        StyledText {
            Layout.fillWidth: true
            text: "自定义组件预览"
            color: root.exampleStyle ? Appearance.colors.colOnPrimaryContainer : Appearance.colors.colOnLayer1
        }
    }
}
