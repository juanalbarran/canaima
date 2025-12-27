// home/modules/quickshell/shell-sway.qml
import Quickshell
import Quickshell.Wayland
import Quickshell.I3
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import "components"

PanelWindow {
  id: root

  // Theme
  property color colBg: "#131314"
  property color colFg: "#a9b1d6"
  property color colMuted: "#444b6a"
  property color colBlue: "#7aa2f7"
  property color colYellow: "#e0af68"
  property color colRed: "#f7768e"
  property color colGreen: "#9ece6a"
  property string fontFamily: "JetBrainsMono Nerd Font"
  property int fontSize: 14
  
  anchors.bottom: true
  anchors.left: true
  anchors.right: true
  implicitHeight: 28
  color: root.colBg

  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: 35
    anchors.rightMargin: 35
    spacing: 10 

    // Workspaces
    Workspaces {
      activeColor: root.colBlue
      fgColor: root.colFg
      mutedColor: root.colMuted
      fontName: root.fontFamily
    }
    // Spacer (pushes everything else to the right)
    Item { Layout.fillWidth: true }

    // SystemTray 
    Tray {
      mutedColor: root.colMuted
      fontName: root.fontFamily
    } 

    // Battery Indicator
    Battery {
      chargingColor: root.colBlue
      lowColor: root.colRed
      fgColor: root.colFg
      yellowColor: root.colYellow
      greenColor: root.colGreen
      fontName: root.fontFamily
      fontSize: root.fontSize
    } 
  }

  Clock {
    anchors.centerIn: parent
    fgColor: root.colFg
    fontName: root.fontFamily
    fontSize: root.fontSize
  }
}
