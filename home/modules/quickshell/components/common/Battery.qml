// home/modules/quickshell/components/common/Battery.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

RowLayout {
  id: batRow
  spacing: 6
  Layout.alignment: Qt.AlignVCenter

  property color chargingColor: "#7aa2f7"
  property color lowColor: "#f7768e"
  property color fgColor: "#a9b1d6"
  property color yellowColor: "#e0af68"
  property color greenColor: "#9ece6a"
  property string fontName: "JetBrainsMono Nerd Font"
  property int fontSize: 14

  readonly property var bat: typeof UPower !== "undefined" ? UPower.displayDevice : null
  visible: bat !== null

  Text {
    property bool isCharging: batRow.bat && (batRow.bat.state === 1)
    text: isCharging ? "󰂄" : "󰁹"
    color: isCharging ? chargingColor : 
           (batRow.bat && batRow.bat.percentage <= 0.2 ? lowColor : 
           (batRow.bat && batRow.bat.percentage < 0.3 ? yellowColor : 
           (batRow.bat && batRow.bat.percentage > 0.7 ? greenColor : fgColor)))
    font { pixelSize: fontSize + 4; family: fontName }
    Layout.alignment: Qt.AlignVCenter
  }

  Text {
    property bool isCharging: batRow.bat && (batRow.bat.state === 1)
    text: batRow.bat ? Math.round(batRow.bat.percentage * 100) + "%" : "0%"
    color: isCharging ? chargingColor : 
           (batRow.bat && batRow.bat.percentage <= 0.2 ? lowColor : 
           (batRow.bat && batRow.bat.percentage < 0.3 ? yellowColor : 
           (batRow.bat && batRow.bat.percentage > 0.7 ? greenColor : fgColor)))
    font { pixelSize: fontSize; family: fontName }
    Layout.alignment: Qt.AlignVCenter
  }
}
