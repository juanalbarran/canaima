// home/modules/quickshell/shell-hyprland.qml
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick

PanelWindow {
  anchors.bottom: true
  anchors.left: true
  anchors.right: true
  implicitHeight: 28
  color: "#000000"

  Text {
    id: timeText
    anchors.centerIn: parent
    color: "#a9b1d6"
    font.pixelSize: 14
    function updateTime() {
      text = Qt.formatDateTime(new Date(), "HH:mm | ddd d")
    }
    Component.onCompleted: updateTime()

    Timer {
      interval: 1000
      running: true
      repeat: true
      onTriggered: parent.updateTime()
    }
  }
}
