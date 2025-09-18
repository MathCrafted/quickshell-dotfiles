import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

ColumnLayout {
    anchors.fill: parent
    RowLayout {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: 40

        // Network
        CustomIcon {
            color: Appearance.colors.backgroundLight
            text {
                // Unicodes: e63e e4ca e4d9 f7a8 e648 eb6b eb2f
                text: Network.networkIcon
                color: Appearance.colors.primary
            }
            mouseArea.enabled: true
            mouseArea.onPressed: (event) => {
                if(event.button == Qt.LeftButton) {
                    Network.toggleWifiPower()
                } else {
                    event.accepted = false
                }
            }
        }

        // HostAP
        CustomIcon {
            color: Appearance.colors.backgroundLight
            text {
                // Unicodes: e1e2 e0ce
                text: "\ue1e2"
                color: Appearance.colors.primary
            }
        }

        // Bluetooth
        CustomIcon {
            color: Appearance.colors.backgroundLight
            text {
                // Unicodes: e1a7 e1a8 e1a9
                text: "\ue1a7"
                color: Appearance.colors.primary
            }
        }
        // VPN Unicodes: e0da f6cc eb7a f350
        // Mic Unicodes: e029
        // Sound sink Unicodes: e79c e04e e04f e050
        // TTS Unicodes: f1bc
        // STT Unicodes: f8a7
        // Assistant Unicodes: ea4a
        // Battery Unicodes: ebdc f7ea ea0b
    }

    // Copypasta from Tray
    RowLayout {
        id: rowLayout

        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        implicitWidth: repeater.count * root.height * 2 / 3 + (repeater.count - 1) * 5
        implicitHeight: root.height * 2 /3
        spacing: 5
        
        Repeater {
            id: repeater
            model: SystemTray.items
            Rectangle {
                id: sysTrayIcon
                required property SystemTrayItem modelData
                Layout.preferredWidth: parent.height
                Layout.preferredHeight: parent.height
                color: Appearance.colors.background

                IconImage {
                    source: parent.modelData.icon
                    anchors.centerIn: parent
                    width: parent.width * scale
                    height: parent.height * scale

                    property real scale: 0.85
                }
                MouseArea {
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    anchors.fill: parent
                    onPressed: (event) => {
                        if (event.button & Qt.RightButton && modelData.hasMenu) {
                            // quickMenuAnchor.open()
                            sysTrayMenuLoader.active = true
                        } else if (event.button & Qt.LeftButton && !modelData.onlyMenu) {
                            modelData.activate()
                        }
                    }
                }
                QsMenuAnchor {
                    id: quickMenuAnchor
                    menu: modelData.menu
                    anchor.window: parentWindow
                }
                Loader {
                    id: sysTrayMenuLoader
                    active: false

                    sourceComponent: PopupWindow {
                        id: sysTrayMenuWindow
                        visible: sysTrayMenuLoader.active
                        anchor {
                            edges: Edges.Bottom | Edges.Left
                            gravity: Edges.Bottom
                            item: parent.parent
                        }
                        implicitWidth: sysTrayMenuBackground.implicitWidth
                        implicitHeight: sysTrayMenuBackground.implicitHeight
                        // property QsMenuOpener sysTrayMenuObject: {
                        //     menu: modelData.menu
                        // }

                        Rectangle {
                            id: sysTrayMenuBackground
                            color: Appearance.colorScheme.background
                            implicitWidth: 50
                            implicitHeight: 50

                            ColumnLayout {
                                anchors {
                                    top: parent.top
                                    left: parent.left
                                }
                                Repeater {
                                    model: sysTrayIcon.modelData
                                    Rectangle {
                                        required property var menuData
                                        color: Appearance.colorScheme.backgroundAlt
                                        implicitWidth: sysTrayButtonText.implicitWidth
                                        implicitHeight: sysTrayButtonText.implicitHeight

                                        Text {
                                            id: sysTrayButtonText
                                            color: Appearance.colorScheme.primary
                                            text: parent.menuData.text
                                        }
                                    }
                                }
                            }
                        }
                        MouseArea {
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            hoverEnabled: true
                            anchors.fill: sysTrayMenuBackground
                            onExited: () => {
                                sysTrayMenuLoader.active = false
                            }
                        }
                    }
                }
            }
        }
    }
}