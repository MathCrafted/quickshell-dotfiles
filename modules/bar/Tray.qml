import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

import qs.common

Rectangle {
    id: root

    property QtObject parentWindow

    implicitWidth: 10 + rowLayout.implicitWidth + 10
    height: parent.height
    color: Appearance.colors.background
    radius: 15
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