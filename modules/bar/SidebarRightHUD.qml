import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.common
import qs.common.widgets
import qs.services

Rectangle {
    height: parent.height
    implicitWidth: layout.implicitWidth + Math.min(2 * radius, height) * 0.8
    color: States.sidebarRightActive ? Appearance.colors.primary : Appearance.colors.background
    radius: height / 2
    RowLayout {
        id: layout
        anchors.centerIn: parent
        height: parent.height
        spacing: 5
        CustomIcon {
            Layout.alignment: Qt.AlignVCenter
            text {
                text: Network.networkIcon
                color: States.sidebarRightActive ? Appearance.colors.background : Appearance.colors.primary
            }
        }
        CustomIcon {
            Layout.alignment: Qt.AlignVCenter
            text {
                text: "\ue050"
                color: States.sidebarRightActive ? Appearance.colors.background : Appearance.colors.primary
            }
        }
    }
    MouseArea {
        id: mouseArea
        acceptedButtons: Qt.LeftButton
        anchors.fill: parent
        onReleased: (event) => {
            if(event.button == Qt.LeftButton) {
                States.sidebarRightActive = !States.sidebarRightActive
            }
        }
    }
}