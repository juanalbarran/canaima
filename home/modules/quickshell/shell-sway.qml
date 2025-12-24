// home/modules/quickshell/shell-sway.qml
import Quickshell
import Quickshell.Wayland
import Quickshell.I3
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower
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
    spacing: 12

    // Workspaces
    Repeater {
      model: 4
      Text {
        property bool isActive: I3.focusedWorkspace !== null && I3.focusedWorkspace.name == (index + 1).toString()
        property bool exists: I3.workspaces.values.some(w => w.name == (index + 1).toString())
        visible: exists || isActive
        text: "󰑊"
        color: isActive ? root.colCyan : (exists ? root.colBlue : root.colMuted)
        font { 
          pixelSize: root.fontSize;
          family: root.fontFamily;
          bold: isActive
        }

        MouseArea {
          anchors.fill: parent
          onClicked: I3.dispatch("workspace " + (index + 1))
        }
      }
    }
    Item { Layout.fillWidth: true }
  
    RowLayout {
      spacing: 4
      Repeater {
        model: SystemTray.items
        
        Image {
          Layout.preferredWidth: 20
          Layout.preferredHeight: 20
          source: modelData.icon
          fillMode: Image.PreserveAspectFit
          
          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            // specific click handling depends on backend, but standard is:
            onClicked: modelData.activate()
          }
        }
      }
    }

    // Divider
    Text { 
        text: "|"
        color: root.colMuted
        font { pixelSize: root.fontSize; family: root.fontFamily }
        visible: SystemTray.items.length > 0
    }

    // 2. Battery Indicator
    RowLayout {
      spacing: 6
      property var bat: UPower.displayDevice
      
      Text {
        // Simple logic: Change color if low (<= 20%) or charging
        color: bat.state === UPower.State.Charging ? root.colYellow : (bat.percentage <= 0.2 ? root.colRed : root.colFg)
        
        // Icon logic: Show bolt if charging, battery if not
        text: bat.state === UPower.State.Charging ? "󰂄" : "󰁹" 
        font { pixelSize: root.fontSize + 2; family: root.fontFamily }
      }
      
      Text {
        text: Math.round(bat.percentage * 100) + "%"
        color: root.colFg
        font { pixelSize: root.fontSize; family: root.fontFamily }
      }
    }
  }

  Text {
    id: timeText
    anchors.centerIn: parent
    color: root.colFg
    font { pixelSize: 14; family: root.fontFamily }
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
