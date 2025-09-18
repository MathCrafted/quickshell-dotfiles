import QtQuick

import qs.common
import qs.services

Rectangle {
    id: root
    focus: true
    
    implicitWidth: 6 * text.text.length + Math.min(2 * radius, height)
    height: parent.height
    color: UtilTimer.flashOn ? Appearance.colors.primary : Appearance.colors.background
    radius: height / 2

    Text {
        id: text
        anchors.centerIn: parent
        color: UtilTimer.flashOn ? Appearance.colors.background : Appearance.colors.primary
        font: Appearance.fontScheme.bar
        text: {
            // Break up time into minutes and seconds
            let seconds = UtilTimer.timeRemaining % 60
            let minutes = (UtilTimer.timeRemaining - seconds) / 60
            
            // Format it into a string
            let stringFormatted = ""
            if (minutes < 10) {stringFormatted += "0"}
            stringFormatted += minutes + ":"
            if (seconds < 10) {stringFormatted += "0"}
            stringFormatted += seconds
            // console.log(stringFormatted)
            return stringFormatted;
        }
    }

    HoverHandler {
        id: hoverHandler
        acceptedDevices: PointerDevices.AllDevices
        // .hovered (bool)
    }
    Keys.onPressed: (event) => {
        if (hoverHandler.hovered && !UtilTimer.isActive && UtilTimer.timeRemaining == UtilTimer.timeTotal) {
            // console.log("Hello")
            if (event.key == Qt.Key_W) {
                // Mouse scrolled up
                if ((Qt.ControlModifier) & event.modifiers) {
                    // Control is held, steps are 1 second
                    UtilTimer.timeTotal += 1
                } else if ((Qt.ShiftModifier) & event.modifiers) {
                    // Shift is held, use the shift steps
                    UtilTimer.timeTotal = UtilTimer.timeTotal - (UtilTimer.timeTotal % UtilTimer.stepShiftScroll) + UtilTimer.stepShiftScroll
                } else {
                    // Use default steps
                    UtilTimer.timeTotal = UtilTimer.timeTotal - (UtilTimer.timeTotal % UtilTimer.stepScroll) + UtilTimer.stepScroll
                }
            } else if (event.key == Qt.Key_S) {
                // Mouse scrolled down
                if ((Qt.ControlModifier) & event.modifiers) {
                    // Control is held, steps are 1 second
                    UtilTimer.timeTotal -= 1
                } else if ((Qt.ShiftModifier) & event.modifiers) {
                    // Shift is held, use the shift steps
                    UtilTimer.timeTotal -= (UtilTimer.timeTotal % UtilTimer.stepShiftScroll) ? 0 : UtilTimer.stepShiftScroll
                    UtilTimer.timeTotal = UtilTimer.timeTotal - (UtilTimer.timeTotal % UtilTimer.stepShiftScroll)
                } else {
                    // Use default steps
                    UtilTimer.timeTotal -= (UtilTimer.timeTotal % UtilTimer.stepScroll) ? 0 : UtilTimer.stepScroll
                    UtilTimer.timeTotal = UtilTimer.timeTotal - (UtilTimer.timeTotal % UtilTimer.stepScroll)
                }
                // Minimum of 1 second on the timer
                UtilTimer.timeTotal = Math.max(1, UtilTimer.timeTotal)
            }
            UtilTimer.timeRemaining = UtilTimer.timeTotal
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.AllButtons
        onPressed: (event) => {
            if (event.button === Qt.LeftButton) {
                // Start/stop the timer
                UtilTimer.isActive = !UtilTimer.isActive
                UtilTimer.isFlashing = UtilTimer.timeRemaining > 0 ? false : true
                UtilTimer.flashOn = false
            } else if (event.button === Qt.RightButton) {
                // Reset the timer
                UtilTimer.isActive = false
                UtilTimer.isFlashing = false
                UtilTimer.flashOn = false
                if ((Qt.ControlModifier) & event.modifiers) {
                    // Control is held, set timer to default time
                    UtilTimer.timeTotal = UtilTimer.defaultTime
                }
                UtilTimer.timeRemaining = UtilTimer.timeTotal
            } else if (event.button == Qt.MiddleButton) {
                // Reset the timer to the default time
                UtilTimer.isActive = false
                UtilTimer.flashOn = false
                UtilTimer.timeTotal = UtilTimer.defaultTime
                UtilTimer.timeRemaining = UtilTimer.timeTotal
            }
        }
        onWheel: (event) => {
            if (!UtilTimer.isActive && UtilTimer.timeRemaining == UtilTimer.timeTotal) {
                // console.log(event.angleDelta.y)
                if (event.angleDelta.y >= 120) {
                    // Mouse scrolled up
                    if ((Qt.ControlModifier) & event.modifiers) {
                        // Control is held, steps are 1 second
                        UtilTimer.timeTotal += 1
                    } else if ((Qt.ShiftModifier) & event.modifiers) {
                        // Shift is held, use the shift steps
                        UtilTimer.timeTotal = UtilTimer.timeTotal - (UtilTimer.timeTotal % UtilTimer.stepShiftScroll) + UtilTimer.stepShiftScroll
                    } else {
                        // Use default steps
                        UtilTimer.timeTotal = UtilTimer.timeTotal - (UtilTimer.timeTotal % UtilTimer.stepScroll) + UtilTimer.stepScroll
                    }
                } else if (event.angleDelta.y <= -120) {
                    // Mouse scrolled down
                    if ((Qt.ControlModifier) & event.modifiers) {
                        // Control is held, steps are 1 second
                        UtilTimer.timeTotal -= 1
                    } else if ((Qt.ShiftModifier) & event.modifiers) {
                        // Shift is held, use the shift steps
                        UtilTimer.timeTotal -= (UtilTimer.timeTotal % UtilTimer.stepShiftScroll) ? 0 : UtilTimer.stepShiftScroll
                        UtilTimer.timeTotal = UtilTimer.timeTotal - (UtilTimer.timeTotal % UtilTimer.stepShiftScroll)
                    } else {
                        // Use default steps
                        UtilTimer.timeTotal -= (UtilTimer.timeTotal % UtilTimer.stepScroll) ? 0 : UtilTimer.stepScroll
                        UtilTimer.timeTotal = UtilTimer.timeTotal - (UtilTimer.timeTotal % UtilTimer.stepScroll)
                    }
                    // Minimum of 1 second on the timer
                    UtilTimer.timeTotal = Math.max(1, UtilTimer.timeTotal)
                }
                UtilTimer.timeRemaining = UtilTimer.timeTotal
            }
        }
    }
}