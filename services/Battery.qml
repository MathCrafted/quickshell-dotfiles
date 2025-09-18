pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property int percentBattery
    property bool flashOn: false

    // Update battery
    Process {
        id: procBattery
        command: ["cat", "/sys/class/power_supply/BAT1/capacity"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.percentBattery = this.text
        }
    }
    Timer {
        interval: 10 * 1000
        running: true
        repeat: true
        onTriggered: procBattery.running = true
    }

    // Flash animation
    Timer {
        interval: 0.3 * 1000
        running: percentBattery <= 10
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            flashOn = !flashOn
        }
    }
    Timer {
        interval: 1
        running: percentBattery > 10
        repeat: false
        triggeredOnStart: true
        onTriggered: {
            flashOn = false
        }
    }
}