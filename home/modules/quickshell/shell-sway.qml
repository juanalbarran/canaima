// home/modules/quickshell/shell-sway.qml
import Quickshell
import Quickshell.Wayland
import Quickshell.I3
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
