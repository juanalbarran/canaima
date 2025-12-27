// home/modules/quickshell/components/common/Tray.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

RowLayout {
  spacing: 4
  property color mutedColor: "#444b6a"
  property string fontName: "JetBrainsMono Nerd Font"
  property int fontSize: 14

  Repeater {
    model: SystemTray.items
    Image {
      Layout.preferredWidth: 20
      Layout.preferredHeight: 20
      Layout.alignment: Qt.AlignVCenter
      source: modelData.icon
      fillMode: Image.PreserveAspectFit
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
    font { pixelSize: fontSize; family: fontName }
    visible: SystemTray.items.length > 0
  }
}
