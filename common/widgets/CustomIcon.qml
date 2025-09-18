import Quickshell
import QtQuick
import ".."

Rectangle {
    id: root
    implicitWidth: objText.implicitWidth
    height: parent.height
    color: "#00000000"
    // debug: hitbox
    // color: "#7f000000"

    property bool isBrand: false
    property Text text: objText
    property MouseArea mouseArea: mouseArea

    Text {
        id: objText
        anchors.centerIn: parent
        font.family: root.isBrand ? Appearance.fonts.brandIcon : Appearance.fonts.icon
    }
    MouseArea {
        id: mouseArea
        acceptedButtons: Qt.AllButtons
        anchors.fill: parent
        enabled: false
    }
}