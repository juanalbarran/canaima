// home/modules/quickshell/componets/common/CPU.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import QtQuick.Controls

RowLayout {
    id: root

    property color chillColor: "#a9b1d6"
    property color dangerColor: "#f7768e"
    property string fontName: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    property var lastTotal: 0
    property var lastIdle: 0
    property int usagePercent: 0

    Process {
        id: cpuProc
        command: ["cat", "/proc/stat"]

        onRunningChanged: {
            if (!running && cpuProc.exitCode === 0) {
                var lines = cpuProc.stdout.split("\n");
                if (lines.length > 0) {
                    var parts = lines[0].split(/\s+/);

                    var user = parseInt(parts[1]);
                    var nice = parseInt(parts[2]);
                    var system = parseInt(parts[3]);
                    var idle = parseInt(parts[4]);
                    var iowait = parseInt(parts[5]);
                    var irq = parseInt(parts[6]);
                    var softirq = parseInt(parts[7]);
                    var steal = parseInt(parts[8]);

                    var total = user + nice + system + idle + iowait + irq + softirq + steal;

                    var diffTotal = total - root.lastTotal;
                    var diffIdle = idle - root.lastIdle;

                    if (diffTotal > 0) {
                        root.usagePercent = Math.floor(((diffTotal - diffIdle) / diffTotal) * 100);
                    }

                    root.lastTotal = total;
                    root.lastIdle = idle;
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: cpuProc.running = true
    }
    Text {
        id: cpuIcon
        text: ""
        color: root.chillColor
        font.family: root.fontName
        font.pixelSize: root.fontSize

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
        }

        ToolTip {
            id: toolTip
            visible: mouseArea.containsMouse
            delay: 100
            timeout: 5000

            // 1. Give breathing room so text doesn't overflow
            padding: 8

            // 2. Manual Position Calculation
            // We calculate: - (Text Height + Top Padding + Bottom Padding + Margin)
            // 12px (approx text) + 8px (top) + 8px (bottom) + 6px (margin above icon)
            y: -45

            // Center horizontally
            x: (parent.width - width) / 2

            contentItem: Text {
                id: ttText // We ID this to reference its height for positioning
                text: "CPU: " + root.usagePercent + "%"
                color: root.chillColor
                font.family: root.fontName
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                color: "#1a1b26"
                border.color: "#414868"
                radius: 4
            }
        }
    }
}
