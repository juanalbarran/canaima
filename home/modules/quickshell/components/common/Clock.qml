// home/modules/quickshell/components/common/Clock.qml
import QtQuick

Text {
  property color fgColor: "#a9b1d6"
  property string fontName: "JetBrainsMono Nerd Font"
  property int fontSize: 14

  color: fgColor
  font { pixelSize: fontSize; family: fontName }

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
