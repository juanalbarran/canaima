// home/modules/quickshell/shell-hyprland.qml
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

PanelWindow {
  id: root

  // Theme
  property color colBg: "#000000"
  property color colFg: "#a9b1d6"
  property color colMuted: "#444b6a"
  property color colCyan: "#0db9d7"
  property color colBlue: "#7aa2f7"
  property color colYellow: "#e0af68"
  property string fontFamily: "JetBrainsMono Nerd Font"
  property int fontSize: 14
  
  anchors.bottom: true
  anchors.left: true
  anchors.right: true
  implicitHeight: 28
  color: root.colBg

  RowLayout {
    anchors.fill: parent
    anchors.margins: 8
    spacing: 8

    // Workspaces
    Repeater {
      model: 4

      Text {
        property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
        property bool isActive: Hyprland.focusedWorspace?.id === (index + 1)
        text: "󰑊"
        color: isActive ? "#0db9d7" : (ws ? "#7aa2f7" : "#444b6a")
        font { pixelSize: 14; bold: true }

        MouseArea {
          anchors.fill: parent
          onClicked: Hyprland.dispatch("workspace " + (index + 1))
        }
      }
    }
    Item { Layout.fillWidth: true}
  }

  // Text {
  //   id: timeText
  //   anchors.centerIn: parent
  //   color: "#a9b1d6"
  //   font.pixelSize: 14
  //   function updateTime() {
  //     text = Qt.formatDateTime(new Date(), "HH:mm | ddd d")
  //   }
  //   Component.onCompleted: updateTime()
  //
  //   Timer {
  //     interval: 1000
  //     running: true
  //     repeat: true
  //     onTriggered: parent.updateTime()
  //   }
  // }
}
