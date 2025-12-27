// home/modules/quickshell/components/sway/Workspaces.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.I3

RowLayout {
  property color activeColor: "#7aa2f7"
  property color fgColor: "#a9b1d6"
  property color mutedColor: "#444b6a"
  property string fontName: "JetBrainsMono Nerd Font"

  spacing: 10

  Repeater {
    model: {
      let max = 4;
      if (typeof I3 !== "undefined" && I3.workspaces && I3.workspaces.values) {
        for (let w of I3.workspaces.values) {
          let num = parseInt(w.name);
          if (!isNaN(num) && num > max) max = num;
        }
      }
      return max;
    }

    Text {
      property bool isActive: (typeof I3 !== "undefined" && I3.focusedWorkspace) && I3.focusedWorkspace.name == (index + 1).toString()
      property bool exists: (typeof I3 !== "undefined" && I3.workspaces) ? I3.workspaces.values.some(w => w.name == (index + 1).toString()) : false

      text: isActive ? "" : "󰄰"
      color: isActive ? activeColor : (exists ? activeColor : mutedColor)
      Layout.alignment: Qt.AlignVCenter
            
      font { 
        pixelSize: 10
        family: fontName
        bold: isActive 
      }

      MouseArea {
        anchors.fill: parent
        onClicked: I3.dispatch("workspace " + (index + 1))
      }
    }
  }
}
