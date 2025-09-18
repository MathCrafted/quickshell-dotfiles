pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    readonly property string time: {
        // https://doc.qt.io/qt-6/qml-qtqml-qt.html#formatDateTime-method
        Qt.formatDateTime(clock.date, "hh:mm:ss t")
    }

    // Update clock
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}