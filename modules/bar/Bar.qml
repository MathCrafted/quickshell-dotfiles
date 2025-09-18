import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import qs.common


Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: barWindow
            property var modelData
            screen: modelData
            focusable: true

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 35
            color: Appearance.colors.backgroundDark

            property int yPadding: 5

            // Left of bar
            RowLayout {
                id: left
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                }
                height: parent.height - 2 * barWindow.yPadding
                spacing: 5

                //
            }

            // Center of bar
            RowLayout {
                id: center
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                height: parent.height - 2 * barWindow.yPadding
                spacing: 5

                Spotify {
                    id: wdgSpotify
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                }
                UtilTimer {
                    id: wdgTimer
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                }
            }

            // Right of bar
            RowLayout {
                id: right
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 10
                }
                height: parent.height - 2 * barWindow.yPadding
                spacing: 5

                PwOut {
                    id: wdgPwOut
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                }
                Battery {
                    id: wdgBattery
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                }
                // Tray {
                //     id: wdgTray
                //     Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                //     parentWindow: barWindow
                // }
                Clock {
                    id: wdgClock
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                }
                SidebarRightHUD {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                }
            }
        }
    }
}