// home/modules/quickshell/components/common/Wifi.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

RowLayout {
    id: root

    property color activeColor: "#7aa2f7"
    property color disconnectedColor: "#f7768e"
    property string fontName: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    property bool isConnected: false

    Process {
        id: nmcli
        // Command: List devices and their state (e.g., "wifi:connected", "ethernet:unavailable")
        command: ["@bash@", "-c", "@nmcli@ -t -f TYPE,STATE device"]

        onRunningChanged: {
            if (!running) {
            if (nmcli.exitCode !== 0) {
                console.error("NMCLI FAILED. Exit Code: " + nmcli.exitCode)
                console.error("Stderr: " + (nmcli.stderr || "empty"))
                console.error("Stdout: " + (nmcli.stdout || "empty"))                
                root.isConnected = false
                return
            }
            var output = nmcli.stdout.trim()
            console.log("NMCLI SUCCESS: " + output)
            
            // Debugging: This prints to your terminal running quickshell
            console.log("Wifi Status Check: " + output)

            // Logic: If ANY line says "wifi:connected", we are good.
            if (output.indexOf("wifi:connected") !== -1) {
                root.isConnected = true
            } else {
                root.isConnected = false
            }
        }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: nmcli.running = true
    }

    // Only one Text element remains: The Icon
    Text {
        text: root.isConnected ? "󰤨" : "󰤮"
        color: root.isConnected ? root.activeColor : root.disconnectedColor
        font.family: root.fontName
        font.pixelSize: root.fontSize
    }
}
