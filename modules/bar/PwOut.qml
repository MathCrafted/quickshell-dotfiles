import Quickshell.Services.Pipewire
import QtQuick

import qs.common

Rectangle {
    id: root
    focus: textSinkName.hoverHandler || textVolumePercent.hoverHandler
    
    height: parent.height
    implicitWidth: textSinkName.implicitWidth + textVolumePercent.implicitWidth + radius
    radius: 15
    color: Appearance.colors.background

    Text {
        id: textSinkName
        anchors {
            right: textVolumePercent.left
            verticalCenter: parent.verticalCenter
        }
        color: Appearance.colors.primary
        font: Appearance.fontScheme.bar
        text: (Pipewire.defaultAudioSink.nickname!="" ? Pipewire.defaultAudioSink.nickname : (Pipewire.defaultAudioSink.properties["media.name"]!="" ? Pipewire.defaultAudioSink.properties["media.name"] : Pipewire.defaultAudioSink.name)) + ": "
        
        property var hoverHandler: textSinkNameHoverHandler
        HoverHandler {
            id: textSinkNameHoverHandler
            acceptedDevices: PointerDevice.AllPointerTypes
        }
    }

    Text {
        id: textVolumePercent
        anchors {
            right: parent.right
            rightMargin: parent.radius / 2
            verticalCenter: parent.verticalCenter
        }
        color: Appearance.colors.primary
        font: Appearance.fontScheme.bar
        text: {
            let volume = Pipewire.defaultAudioSink.audio.volume
            return Pipewire.defaultAudioSink.audio.muted ? "0%" : volume * 100 - (volume * 100 % 1) + "%"
        }
        property var hoverHandler: textVolumePercentHoverHandler
        HoverHandler {
            id: textVolumePercentHoverHandler
            acceptedDevices: PointerDevice.AllPointerTypes
        }
    }

    Component.onCompleted: {
        Pipewire.defaultAudioSink.connect(() => {
            PwObjectTracker.list.push(Pipewire.defaultAudioSink)
        })
    }

    // Sink name
    MouseArea {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: textSinkName.right
        }
        acceptedButtons: Qt.AllButtons

        onPressed: (event) => {
            if (event.button == Qt.LeftButton) {
                // Left button clicked
            }
        }

        onWheel: (event) => {
            // Switch audio sink
        }
    } 

    // Volume
    MouseArea {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: textVolumePercent.left
            right: parent.right
        }
        acceptedButtons: Qt.AllButtons

        onPressed: (event) => {
            if (event.button == Qt.LeftButton) {
                // Left button clicked
                // Mute the sink
                Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
            }
        }

        onWheel: (event) => {
            if (event.angleDelta.y > 0) {
                // Scrolled up
                // Increase volume to maximum of 100
                if ((Qt.ShiftModifier) & event.modifiers) {
                    Pipewire.defaultAudioSink.audio.volume = Math.min(1, Pipewire.defaultAudioSink.audio.volume + 0.01)
                } else {
                    Pipewire.defaultAudioSink.audio.volume = Math.min(1, Pipewire.defaultAudioSink.audio.volume + 0.05)
                }
            } else if (event.angleDelta.y < 0) {
                // Scrolled down
                // Decrease volume to minimum of 0
                if ((Qt.ShiftModifier) & event.modifiers) {
                    Pipewire.defaultAudioSink.audio.volume = Math.max(0, Pipewire.defaultAudioSink.audio.volume - 0.01)
                } else {
                    Pipewire.defaultAudioSink.audio.volume = Math.max(0, Pipewire.defaultAudioSink.audio.volume - 0.05)
                }
            }
        }
    }
    
    // Key Events
    Keys.onPressed: (event) => {
        console.log("Event")
        if(textSinkName.hoverHandler.hovered && (event.key == Qt.Key_W || event.key == Qt.Key_S)) {
            // console.log("Key Event")
            // Swap between PW sinks, according to blacklist
            let arrBlacklist = ["Soundcraft Signature 12 MTK"]
            let i = Pipewire.nodes.indexOf(Pipewire.defaultAudioSink)
            console.log("Current index: " + i)
            Pipewire.nodes.values.forEach((node) => {if(true) {console.log(node.name)}})
            while(true) {
                i = event.key == Qt.Key_W ? i + 1 : i - 1
                i = i >= Pipewire.nodes.values.length ? 0 : i
                i = i < 0 ? Pipewire.nodes.values.length - 1 : i
                if(Pipewire.nodes.values[i].isSink && !arrBlacklist.includes(Pipewire.nodes.values[i].nickname)) {
                    console.log("New index: " + i)
                    Pipewire.preferredDefaultAudioSink = Pipewire.nodes.values[i]
                    break;
                }
            }
        } else if(textVolumePercent.hoverHandler.hovered) {
            // console.log("Key Event")
            // Change Volume
            if(event.key == Qt.Key_W) {
                // Increase volume to maximum of 100
                if ((Qt.ShiftModifier) & event.modifiers) {
                    Pipewire.defaultAudioSink.audio.volume = Math.min(1, Pipewire.defaultAudioSink.audio.volume + 0.01)
                } else {
                    Pipewire.defaultAudioSink.audio.volume = Math.min(1, Pipewire.defaultAudioSink.audio.volume + 0.05)
                }
            } else if (event.key == Qt.Key_S) {// Decrease volume to minimum of 0
                if ((Qt.ShiftModifier) & event.modifiers) {
                    Pipewire.defaultAudioSink.audio.volume = Math.max(0, Pipewire.defaultAudioSink.audio.volume - 0.01)
                } else {
                    Pipewire.defaultAudioSink.audio.volume = Math.max(0, Pipewire.defaultAudioSink.audio.volume - 0.05)
                }
            }
        }
    }

    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }
}