pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property bool ethernetConnected: false
    property bool wifiConnected: false
    property bool wifiAdapterOn: false
    property string networkIcon: wifiConnected ? "\ue1ba" : wifiAdapterOn ? "\ueb31" : "\ue1da"

    function toggleWifiPower() {
        procIwctl.command = ["iwctl","device","wlan0","set-property","Powered",root.wifiAdapterOn ? "off" : "on"]
        procIwctl.running = true
        root.wifiAdapterOn = root.wifiAdapterOn ? false : true
        root.wifiConnected = false
    }
    Process {
        id: procIwctl
        running: false
        command: ["iwctl"]
    }

    // Update Network info
    Process {
        id: procWlan0
        running: false
        command: ["iwctl","station","wlan0","show"]
        stdout: StdioCollector {
            onStreamFinished: {
                let str = text
                // console.log(str.trim().split(":")[0])
                root.wifiAdapterOn = str.trim().split(":")[0] != "No station on device"
                root.wifiConnected = root.wifiAdapterOn ? str.split("State")[1].split("\n")[0].trim() == "connected" : false
            }
        }
    }
    Timer {
        id: timerNetwork
        interval: 1 * 1000
        running: true
        repeat: true
        onTriggered: {
            procWlan0.running = true
        }
    }
}