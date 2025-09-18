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

Scope {
    id: root

    WlrLayershell {
        id: sidebarRightRoot
        visible: States.sidebarRightActive
        focusable: true
        color: "#00000000"

        function hide() {
            States.sidebarRightActive = false
        }

        anchors {
            top: true
            bottom: true
            right: true
        }
        implicitWidth: 200
        exclusionMode: ExclusionMode.Normal
        exclusiveZone: 0

        namespace: "quickshell:sidebarRight"
        keyboardFocus: KeyboardFocus.Exclusive
        layer: WlrLayer.Overlay

        // Adds the rectangle to a mask of pixels to render
        mask: Region {
            item: sidebarRightBackground
        }

        HyprlandFocusGrab {
            id: grab
            windows: [sidebarRightRoot]
            active: sidebarRightRoot.visible
            onCleared: {
                if(!grab.active) {
                    sidebarRightRoot.hide()
                }
            }
        }

        Rectangle {
            id: sidebarRightBackground
            focus: true
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                leftMargin: 0
                margins: 20
            }
            color: Appearance.colors.backgroundDark
            radius: 10
            Keys.onEscapePressed: (event) => {
                sidebarRightRoot.hide()
            }
            SidebarRightContent{}
        }
    }

    GlobalShortcut {
        name: "toggleSidebarRight"
        description: "Toggles the right sidebar"
        onPressed: {
            States.sidebarRightActive = !States.sidebarRightActive
        }
    }
}