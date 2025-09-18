pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // Default time in seconds
    readonly property int defaultTime: 3600
    // Multiple to snap to when scrolling in seconds
    readonly property int stepScroll: 300
    readonly property int stepShiftScroll: 20

    property int timeTotal: 3600
    property int timeRemaining: 3600
    property bool isActive: false
    property bool isFlashing: false
    property bool flashOn: false

    property FileView save: FileView {
        path: "/home/jrhaley/.config/quickshell/saveTimer.json"
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        JsonAdapter {
            property bool isActive: root.isActive
            property int timeTotal: root.timeTotal
            property int timeRemaining: root.timeRemaining
        }
        onLoaded: {
            console.log("Loading Timer state")
            if(root.save.adapter.timeTotal >= 0) {
                root.timeTotal = save.adapter.timeTotal
            }
            if(root.save.adapter.timeRemaining >= 0) {
                root.timeRemaining = save.adapter.timeRemaining
            }
            root.isActive = root.save.adapter.isActive
        }
    }

    // Countdown
    Timer {
        interval: 1 * 1000
        running: root.isActive && !root.isFlashing
        repeat: true
        onTriggered: {
            if (root.timeRemaining > 0) {
                root.timeRemaining -= 1
            } else {
                // Flash widget, notify, or something
                root.isFlashing = true
            }
        }
    }

    // Flash animation
    Timer {
        interval: 0.3 * 1000
        running: root.isActive && root.isFlashing
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            flashOn = !flashOn
        }
    }
}