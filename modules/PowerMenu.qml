import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common

Scope {
    id: root

    // Config
    property int buttonSizePx: 80
    property var jsonPowerMenu: [
        {
            // Exit the power menu
            "text": "\ue88a",
            "fontScheme": Appearance.fontScheme.classicIcon,
            "action": "hide",
            "highlight": false,
            "command": []
        },
        // {
        //     // Logout
        //     "text": "\uf72e",
        //     "fontScheme": Appearance.fontScheme.classicIcon,
        //     "action": "cmd",
        //     "highlight": false,
        //     "command": ["logout"]
        // },
        {
            // Lock the system
            "text": "\ue897",
            "fontScheme": Appearance.fontScheme.classicIcon,
            "action": "cmd",
            "highlight": false,
            "command": ["hyprlock"]
        },
        {
            // Shutdown the system
            "text": "\uf16f",
            "fontScheme": Appearance.fontScheme.classicIcon,
            "action": "cmd",
            "highlight": true,
            "command": ["shutdown","now"]
        },
        {
            // Reboot the system
            "text": "\ue5d5",
            "fontScheme": Appearance.fontScheme.classicIcon,
            "action": "cmd",
            "highlight": true,
            "command": ["reboot"]
        },
        {
            // Reboot into BIOS
            "text": "\ue161",
            "fontScheme": Appearance.fontScheme.classicIcon,
            "action": "cmd",
            "highlight": true,
            "command": ["systemctl", "reboot","--firmware-setup"]
        }
    ]

    Loader {
        id: powerMenuLoader
        active: false

        sourceComponent: WlrLayershell {
            id: powerMenuRoot
            visible: powerMenuLoader.active
            focusable: true
            color: "#7f000000"
            exclusionMode: ExclusionMode.Ignore

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            namespace: "quickshell:powerMenu"
            keyboardFocus: KeyboardFocus.Exclusive
            layer: WlrLayer.Overlay

            // Adds the rectangle to a mask of pixels to render
            mask: Region {
                item: powerMenuBackground
            }

            HyprlandFocusGrab {
                id: grab
                windows: [powerMenuRoot]
                active: powerMenuRoot.visible
                onCleared: {
                    if(!grab.active) {
                        powerMenuLoader.active = false
                    }
                }
            }

            // Window proper
            Rectangle {
                id: powerMenuBackground
                focus: true
                anchors.centerIn: parent
                implicitWidth: padding * 2 + powerMenuGrid.implicitWidth
                implicitHeight: padding * 2 + powerMenuGrid.implicitHeight
                radius: this.padding
                color: Appearance.colorScheme.background

                property int padding: 20
                property int selectedButtonIndex: 0

                Keys.onPressed: (event) => {
                    let length = powerMenuItems.count
                    if(event.key == Qt.Key_Escape) {
                        // Close the power menu
                        powerMenuLoader.active = false
                    } else if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter || event.key == Qt.Key_Space) {
                        // Execute currently selected button's action
                        powerMenuItems.itemAt(selectedButtonIndex).buttonExecHandler()
                    } else if (event.key == Qt.Key_Up || event.key == Qt.Key_W) {
                        // Move selection up if possible
                        selectedButtonIndex -= selectedButtonIndex % 2
                    } else if (event.key == Qt.Key_Down || event.key == Qt.Key_S) {
                        // Move selection down if possible
                        if (selectedButtonIndex % 2 != 2 && selectedButtonIndex + 1 < length) {
                            selectedButtonIndex = selectedButtonIndex - (selectedButtonIndex % 2) + 1
                        } else if (selectedButtonIndex % 2 != 2 && selectedButtonIndex - 1 >= 0) {
                            selectedButtonIndex = selectedButtonIndex - (selectedButtonIndex % 2) - 1
                        }
                    } else if (event.key == Qt.Key_Left || event.key == Qt.Key_A) {
                        // Move selection left if possible
                        if (selectedButtonIndex - 2 >= 0) {
                            selectedButtonIndex -= 2
                        }
                    } else if (event.key == Qt.Key_Right || event.key == Qt.Key_D) {
                        // Move selection right if possible
                        if (selectedButtonIndex + 2 < length) {
                            selectedButtonIndex += 2
                        } else if (selectedButtonIndex + 1 < length) {
                            selectedButtonIndex += 1
                        }
                    }
                }

                GridLayout {
                    id: powerMenuGrid
                    anchors.centerIn: parent
                    flow: GridLayout.TopToBottom
                    rows: 2
                    rowSpacing: parent.padding * 3 / 4
                    columnSpacing: parent.padding * 3 / 4
                    implicitWidth: columns * (root.buttonSizePx + columnSpacing) - columnSpacing
                    implicitHeight: rows * (root.buttonSizePx + rowSpacing) - rowSpacing

                    Repeater {
                        id: powerMenuItems
                        model: root.jsonPowerMenu
                        Button {
                            required property var modelData
                            required property var index
                            hoverEnabled: true
                            onHoveredChanged: {
                                if (hovered == true) powerMenuBackground.selectedButtonIndex = index
                            }
                            function buttonExecHandler() {
                                if (modelData.action == "hide") {
                                    powerMenuLoader.active = false
                                } else if (modelData.action == "cmd") {
                                    process.startDetached()
                                }
                            }
                            onClicked: {
                                buttonExecHandler()
                            }
                            contentItem: Text {
                                anchors.centerIn: parent
                                text: modelData.text
                                color: modelData.highlight ? Appearance.colorScheme.backgroundAlt : Appearance.colorScheme.primary
                                font: modelData.fontScheme
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            background: Rectangle {
                                implicitWidth: root.buttonSizePx
                                implicitHeight: root.buttonSizePx
                                radius: root.buttonSizePx * 3 / 16
                                color: modelData.highlight ? Appearance.colorScheme.primary : Appearance.colorScheme.backgroundAlt
                                state: parent.index == powerMenuBackground.selectedButtonIndex ? "SELECTED" : "DESELECTED"

                                states: [
                                    State {
                                        name: "SELECTED"
                                        PropertyChanges {target: powerMenuItems.itemAt(index).background; radius: implicitHeight / 2}
                                    },
                                    State {
                                        name: "DESELECTED"
                                        PropertyChanges {target: powerMenuItems.itemAt(index).background; radius: root.buttonSizePx * 3 / 16}
                                    }
                                ]

                                transitions: [
                                    Transition {
                                        to: "*"
                                        PropertyAnimation {target: powerMenuItems.itemAt(index).background; properties: "radius"; duration: 100; easing.type: Easing.InOutQuad}
                                    }
                                ]

                            }
                            property var process: Process {
                                running: false
                                command: modelData.command
                            }
                        }
                    }
                }
            }
        }
    }

    GlobalShortcut {
        name: "togglePowerMenu"
        description: "Toggles a menu containing power off options"
        onPressed: {
            powerMenuLoader.active = !powerMenuLoader.active
        }
    }
}