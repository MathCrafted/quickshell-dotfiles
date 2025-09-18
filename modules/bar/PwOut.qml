import Quickshell.Services.Pipewire
import QtQuick

import qs.common

Rectangle {
    height: parent.height
    implicitWidth: 6 * textSinkName.text.length + 6 * textVolumePercent.text.length + Math.min(2 * radius, height)
    radius: 15
    color: Appearance.colors.background

    Text {
        id: textSinkName
        anchors {
            left: parent.left
            leftMargin: 5
            verticalCenter: parent.verticalCenter
        }
        color: Appearance.colors.primary
        font: Appearance.fontScheme.bar
        text: Pipewire.defaultAudioSink.nickname + ":"
    }

    Text {
        id: textVolumePercent
        anchors {
            right: parent.right
            rightMargin: 5
            verticalCenter: parent.verticalCenter
        }
        color: Appearance.colors.primary
        font: Appearance.fontScheme.bar
        text: {
            let volume = Pipewire.defaultAudioSink.audio.volume
            return Pipewire.defaultAudioSink.audio.muted ? "0%" : volume * 100 - (volume * 100 % 1) + "%"
        }
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

    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }
}