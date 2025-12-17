// home/modules/quickshell/shell-hyprland.qml
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick

PanelWindow {
  anchors.bottom: true
  anchors.left: true
  anchors.right: true
  implicitHeight: 30
  color: "#1a1b26"

  Text {
    anchors.centerIn: parent
    text: "Hola pepsi cola :)"
    color: "#a9b1d6"
    font.pixelSize: 14
  }
}
