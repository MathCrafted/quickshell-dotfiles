pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import QtQuick
import QtQml

Singleton {
    id: root

    property real percentPlayback: 0
    property bool flagOpenSpotify: false
    onFlagOpenSpotifyChanged: () => {
        if(flagOpenSpotify) {
            procOpenSpotify.startDetached()
            flagOpenSpotify = false
        }
    }
    Timer {
        interval: 0.5 * 1000
        running: true
        repeat: true
        onTriggered: {
            for (let player of Mpris.players.values) {
                if (player.identity == "Spotify") {
                    root.percentPlayback = 100 * player.position / player.length
                }
            }
        }
    }
    
    Process {
        id: procOpenSpotify
        command: ["spotify"]
        running: false
    }

    // Process {
    //     id: procLaunchSpotify
    //     running: false
    //     command: ["spotify", "--minimized"]
    // }
    // Component.onCompleted: () => {
    //     procLaunchSpotify.startDetached()
    // }
}