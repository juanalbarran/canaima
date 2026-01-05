// home/modules/quickshell/components/common/Tray.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

RowLayout {
    spacing: 4
    property color mutedColor: "#444b6a"
    property string fontName: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    property color spotifyColor: "#a6da95"

    Repeater {
        model: SystemTray.items
        Item {
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            Layout.alignment: Qt.AlignVCenter

            // Detect if this item is Spotify based on ID or Icon name
            // We convert to lowercase to be safe
            readonly property bool isSpotify: (modelData.id && modelData.id.toLowerCase().includes("spotify")) || (modelData.icon && modelData.icon.toLowerCase().includes("spotify"))

            // 1. Standard Icon (Hidden if Spotify)
            Image {
                anchors.fill: parent
                visible: !parent.isSpotify
                source: modelData.icon
                fillMode: Image.PreserveAspectFit
            }

            // 2. Custom Nerd Font Icon (Visible only if Spotify)
            Text {
                anchors.centerIn: parent
                visible: parent.isSpotify
                text: "" // Spotify Icon (nf-fa-spotify)
                color: spotifyColor // Or use 'root.mutedColor' if you prefer
                font.family: fontName
                font.pixelSize: fontSize + 2 // Slightly larger to match icon weight
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: modelData.activate()
            }
        }
    }

    // Divider line
    Text {
        text: "|"
        color: mutedColor
        Layout.alignment: Qt.AlignVCenter
        font {
            pixelSize: fontSize
            family: fontName
        }
        visible: SystemTray.items.length > 0
    }
}
