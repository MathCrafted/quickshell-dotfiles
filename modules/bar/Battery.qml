import QtQuick

import qs.common
import qs.services

Rectangle {
    height: parent.height
    implicitWidth: text.implicitWidth + 10
    color: Battery.flashOn ? Appearance.colors.primary : Appearance.colors.background
    radius: height / 2
    Text {
        id: text
        anchors.centerIn: parent
        color: Battery.flashOn ? Appearance.colors.background : Appearance.colors.primary
        font: Appearance.fontScheme.bar
        text: Battery.percentBattery + "%"
    }
}
