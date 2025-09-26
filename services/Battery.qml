pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property int percentBattery
    property bool pluggedIn
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
    Process {
        id: procAC
        command: ["cat", "/sys/class/power_supply/ACAD/online"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.pluggedIn = this.text.trim() == "1" ? true : false
            }
        }
    }

    // Update the battery percentage and AC adaptor status
    Timer {
        interval: 1 * 1000
        running: true
        repeat: true
        onTriggered: {
            procBattery.running = true
            procAC.running = true
        }
    }

    // Manage flashing
    onPercentBatteryChanged: {
        if(percentBattery <= 10 && !pluggedIn) {
            flashTimer.running = true
        } else {
            flashTimer.running = false
            flashOn = false
        }
    }
    onPluggedInChanged: {
        if(percentBattery <= 10 && !pluggedIn) {
            flashTimer.running = true
        } else {
            flashTimer.running = false
            flashOn = false
        }
    }

    // Flash animation
    Timer {
        id: flashTimer
        interval: 0.3 * 1000
        running: false
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            flashOn = !flashOn
        }
    }
}