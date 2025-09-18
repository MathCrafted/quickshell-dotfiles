import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import qs.common

Scope {
    id: root
    Loader {
        id: colorReadoutLoader
        active: false

        sourceComponent: FloatingWindow {
            id: colorReadoutRoot
            visible: colorReadoutLoader.active
            color: Appearance.colorScheme.background

            // render mask

            // HyprlandFocusGrab {
            //     id: grab
            //     windows: [colorReadoutRoot]
            //     active: colorReadoutLoader.active
            //     // onCleared: {
            //     //     if(!grab.active) {
            //     //         powerMenuLoader.active = false
            //     //     }
            //     // }
            // }

            GridLayout {
                id: colorReadoutRow
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: 40
                }
                width: parent.width - columnSpacing * colorReadoutItems.count
                // height: parent.height - rowSpacing * colorReadoutItems.count
                rowSpacing: 5
                columnSpacing: rowSpacing
                uniformCellWidths: true
                uniformCellHeights: uniformCellWidths
                columns: width / (colorReadoutItems.itemWidth + rowSpacing) - 1

                Repeater {
                    id: colorReadoutItems
                    model: Appearance.wallpaperColors.colors
                    Layout.preferredWidth: count * colorReadoutItems.itemWidth
                    property int itemWidth: 80
                    property int itemRadius: 10
                    property int itemMargin: 5

                    Rectangle {
                        required property var modelData
                        color: Appearance.colorScheme.backgroundAlt
                        radius: colorReadoutItems.itemRadius
                        width: colorReadoutItems.itemWidth + colorReadoutItems.itemMargin * 2
                        height: colorReadoutItems.itemWidth + colorReadoutItems.itemMargin * 2

                        Rectangle {
                            anchors {
                                top: parent.top
                                bottom: text.top
                                left: parent.left
                                right: parent.right
                                margins: colorReadoutItems.itemMargin
                                bottomMargin: colorReadoutItems.itemMargin / 2
                            }
                            width: parent.width - 5
                            height: parent.height - 5
                            radius: parent.radius
                            color: modelData
                        }
                        Text {
                            id: text
                            text: {modelData + "\nLight: " + Math.round(modelData.hslLightness * 100 * 10) / 10 + "%"}
                            color: Appearance.colorScheme.primary
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                bottom: parent.bottom
                                margins: colorReadoutItems.itemMargin
                            }
                        }

                        MouseArea {
                            acceptedButtons: Qt.AllButtons
                            anchors.fill: parent
                            onPressed: (event) => {
                                if(event.button == Qt.LeftButton) {
                                    parent.copy.startDetached()
                                    copyMessage.color = "green"
                                    copyMessageTimer.running = true
                                }
                            }
                        }
                        property Process copy: Process {
                            running: false
                            command: ["wl-copy", modelData]
                        }
                    }
                }
            }
            GridLayout {
                id: paletteReadoutRow
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: copyMessage.bottom
                }
                width: paletteReadoutItems.count * paletteReadoutItems.itemWidth + columnSpacing * paletteReadoutItems.count
                // height: parent.height - rowSpacing * paletteReadoutItems.count
                rowSpacing: 5
                columnSpacing: rowSpacing
                uniformCellWidths: false
                uniformCellHeights: uniformCellWidths
                columns: Math.min(width / (paletteReadoutItems.itemWidth + rowSpacing) - 1, 3)

                Repeater {
                    id: paletteReadoutItems
                    model: [Appearance.colors.primaryLight, Appearance.colors.primary, Appearance.colors.primaryDark, Appearance.colors.secondaryLight, Appearance.colors.secondary, Appearance.colors.secondaryDark, Appearance.colors.backgroundLight, Appearance.colors.background, Appearance.colors.backgroundDark, Appearance.colors.text]
                    Layout.preferredWidth: count * paletteReadoutItems.itemWidth
                    property int itemWidth: 80
                    property int itemRadius: 10
                    property int itemMargin: 5

                    Rectangle {
                        required property var modelData
                        color: Appearance.colorScheme.backgroundAlt
                        radius: paletteReadoutItems.itemRadius
                        width: paletteReadoutItems.itemWidth + paletteReadoutItems.itemMargin * 2
                        height: paletteReadoutItems.itemWidth + paletteReadoutItems.itemMargin * 2

                        Rectangle {
                            anchors {
                                top: parent.top
                                bottom: text.top
                                left: parent.left
                                right: parent.right
                                margins: paletteReadoutItems.itemMargin
                                bottomMargin: paletteReadoutItems.itemMargin / 2
                            }
                            width: parent.width - 5
                            height: parent.height - 5
                            radius: parent.radius
                            color: modelData
                        }
                        Text {
                            id: text
                            text: {modelData + "\nLight: " + Math.round(modelData.hslLightness * 100 * 10) / 10 + "%"}
                            color: Appearance.colorScheme.primary
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                bottom: parent.bottom
                                margins: paletteReadoutItems.itemMargin
                            }
                        }
                    }
                }
            }
            Text {
                id: copyMessage
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: colorReadoutRow.bottom
                }
                text: "Copied to Clipboard"
                color: Appearance.colorScheme.background
                Timer {
                    id: copyMessageTimer
                    running: false
                    interval: 2 * 1000
                    onTriggered: copyMessage.color = Appearance.colorScheme.background
                    // onTriggered: PropertyAnimation { target: "copyMessage"; property: "color"; duration: 1 * 1000; easing.type: Easing.OutQuad; to: Appearance.colorScheme.background }
                }
            }
        }
    }

    GlobalShortcut {
        name: "toggleColorReadout"
        description: "Toggles a readout windows display the component colors of the background"
        onPressed: {
            colorReadoutLoader.active = !colorReadoutLoader.active
        }
    }
}