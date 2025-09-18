import Quickshell.Services.Mpris
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.common
import qs.services

Rectangle {
    id: root

    implicitWidth: rowLayout.anchors.leftMargin + rowLayout.implicitWidth + rowLayout.anchors.rightMargin
    height: parent.height
    color: Appearance.colors.background
    radius: 15

    RowLayout {
        id: rowLayout

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 10
            rightMargin: 13
        }
        implicitWidth: {
            let itemWidth = 0
            for(let child of children) {
                itemWidth += child.implicitWidth
            }
            return itemWidth + spacing * (children.length - 1)
        }
        height: parent.height
        spacing: 5

        Text {
            id: spotifyLogo
            color: Appearance.colors.primary
            font: Appearance.fontScheme.brandsIcon
            text: "\uf1bc" // Spotify Logo

            MouseArea {
                id: spotifyLogoMouse
                anchors {
                    verticalCenter: spotifyLogo.verticalCenter
                    horizontalCenter: spotifyLogo.horizontalCenter
                }
                width: spotifyLogo.width
                height: spotifyLogo.height
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onPressed: (event) => {
                    if (event.button == Qt.LeftButton) {
                        for (let player of Mpris.players.values) {
                            if (player.identity == "Spotify") {
                                // Play/pause spotify
                                player.isPlaying = !player.isPlaying
                            }
                        }
                    } else if (event.button == Qt.RightButton) {
                        // Launch spotify
                        Spotify.flagOpenSpotify = true
                    }
                }
            }
        }

        // Slider
        Rectangle {
            id: slider
            implicitWidth: 150
            implicitHeight: 5
            radius: 5
            color: Appearance.colors.background

            Rectangle {
                id: sliderComplete
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    right: sliderKnob.left
                    rightMargin: 3
                }
                implicitHeight: parent.implicitHeight
                radius: parent.radius
                color: Appearance.colors.primary
            }
            Rectangle {
                id: sliderIncomplete
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: sliderKnob.right
                    right: parent.right
                    leftMargin: 3
                }
                implicitHeight: parent.implicitHeight
                radius: parent.radius
                color: Appearance.colors.backgroundLight
            }
            Rectangle {
                id: sliderKnob
                anchors {
                    verticalCenter: parent.verticalCenter
                }
                x: Spotify.percentPlayback * (slider.implicitWidth - this.width) / 100 + this.width/2

                implicitHeight: 2 * parent.height
                implicitWidth: 2 * parent.height
                radius: 2 * parent.radius
                color: Appearance.colors.primary
                Component.onCompleted: {sliderKnob.x = Qt.binding(() => {
                    Spotify.percentPlayback * (slider.implicitWidth - this.width) / 100 + this.width/2
                })}
            }

            MouseArea {
                id: sliderMouse
                anchors {
                    verticalCenter: slider.verticalCenter
                    horizontalCenter: slider.horizontalCenter
                }
                height: root.height
                width: slider.width + slider.height * 2
                acceptedButtons: Qt.LeftButton
                drag {
                    target: sliderKnob
                    axis: Drag.XAxis
                    minimumX: 0
                    maximumX: slider.width - sliderKnob.width
                    threshold: 0
                }
                onPressed: (event) => {
                    sliderKnob.x = mouseX - sliderKnob.width/2
                }
                onReleased: (event) => {
                    console.log(sliderKnob.x, " vs ", mouseX)
                    for (let player of Mpris.players.values) {
                        if (player.identity == "Spotify") {
                            // Set player position wherever the knob is dropped
                            console.log(sliderKnob.x / (slider.width-sliderKnob.width) * player.length)
                            player.position = sliderKnob.x / (slider.width-sliderKnob.width) * player.length
                        }
                    }
                }
            }
        }
    }
    
    // Update the sliders with the current playback percentage
    Connections {
        target: Spotify
        function onPercentPlaybackChanged() {
            if (!(sliderMouse.pressedButtons & Qt.LeftButton)) {
                sliderKnob.x = Spotify.percentPlayback * 1.5 - 5
            }
        }
    }
}