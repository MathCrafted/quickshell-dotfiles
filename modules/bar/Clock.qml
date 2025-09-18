import QtQuick

import qs.common
import qs.services

Rectangle {
    height: parent.height
    implicitWidth: 6 * text.text.length + Math.min(2 * radius, height)
    color: Appearance.colors.background
    radius: height / 2
    Text {
        id: text
        anchors.centerIn: parent
        color: Appearance.colors.primary
        font: Appearance.fontScheme.bar
        text: Clock.time
    }
}