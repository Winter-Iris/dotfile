import QtQuick
import Quickshell.Io
import qs.modules.common

Item {
    id: root
    visible: false
    implicitWidth: 0
    implicitHeight: 0

    // Keep custom settings out of upstream config.json.
    property alias options: settingsAdapter

    FileView {
        id: settingsFile
        path: `${Directories.shellConfig}/custom-components.json`
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        onLoadFailed: error => {
            if (error === FileViewError.FileNotFound) writeAdapter();
        }

        JsonAdapter {
            id: settingsAdapter

            property JsonObject appearance: JsonObject {
                // Example only. Future upstream style hooks can read this value.
                property bool exampleStyle: false
            }

            property bool customNotificationEmptyState: true
        }
    }
}
