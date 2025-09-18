pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string defaultMode: wallpaperColors.colors[0].hslLightness < 1 - wallpaperColors.colors[wallpaperColors.colors.length-1].hslLightness ? "dark" : "light"
    property string mode: "dark"
    property QtObject colors
    property QtObject colorScheme //deprecating
    property QtObject fonts
    property QtObject fontSizes
    property QtObject fontScheme //deprecating
    property ColorQuantizer wallpaperColors

    property FileView config: FileView {
        path: "/home/jrhaley/.config/quickshell/common/Appearance.json"
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        JsonAdapter {
            property string fileWallpaper: "sakuraPhotoHires.png"
            property string pathWallpaper: "/home/jrhaley/.local/share/wallpapers/"
            property int intDefaultRescale: 1024
            property int intDefaultDepth: 4
        }
    }
    wallpaperColors: ColorQuantizer {
        rescaleSize: root.config.adapter.intDefaultRescale
        depth: root.config.adapter.intDefaultDepth
        source: Qt.resolvedUrl(root.config.adapter.pathWallpaper + root.config.adapter.fileWallpaper)
    }

    Process {
        id: openRGB
        running: false
        command: ["openrgb","--color",""+root.colors.primary.r+root.colors.primary.g+root.colors.primary.b]
    }
    colors: QtObject {
        property color backgroundDark: Qt.hsla(background.hslHue, background.hslSaturation, background.hslLightness - 0.05, 1)
        property color background: wallpaperColors.colors[0].hslLightness < 1/3 ? wallpaperColors.colors[0] : "#303030"
        property color backgroundLight: wallpaperColors.colors[1].hslLightness < 1/2 ? wallpaperColors.colors[1] : "#505050"
        property color secondaryDark: "#FF00FF"
        property color secondary: "#FF00FF"
        property color secondaryLight: "#FF00FF"
        property color primaryDark: "#FF00FF"
        property color primary: {
            let selection = root.mode == "dark" ? "#EFEFEF" : "#202020"
            for(let color of wallpaperColors.colors) {
                if(root.mode == "dark" && color.hslLightness >= 75/100) {
                    selection = color
                } else if (root.mode == "light" && color.hslLightness <= 25/100) {
                    selection = color
                }
            }
            return selection
        }
        property color primaryLight: "#FF00FF"
        property color text: root.mode == "dark" ? "#FFFFFF" : "#000000"

        onPrimaryChanged: {
            console.log("Starting OpenRGB")
            openRGB.startDetached()
        }
    }

    colorScheme: QtObject {
        // Maybe one day...
        // property Palette palette {
        //     button: "#404040"
        //     buttonText: this.text
        //     text: "#FFC0CB"
        //     toolTipBase: "#202020"
        //     toolTipText: this.text
        //     window: "#303030"
        //     windowText: this.text
        // }

        // Basic color palette which should cover all my needs :)
        property color background: "#303030" // Background dark
        property color backgroundAlt: "#404040" // Background
        property color backgroundLight: "#505050"
        property color progressIncomplete: "#79FFFFFF" // Secondary/Primary a=0.5
        property color progressComplete: "#FFC0CB" // Nix
        property color primaryAlt: "#9d3b4b"
        // property color primaryDark: ""
        property color primary: "#FFC0CB"
        // property color primaryLight: ""
        property color text: "#ffffff"
    }

    fontScheme: QtObject {
        // Font presets:
        property font bar: ({
            family: rubik.name,
            pixelSize: 13,
            bold: true
        })
        property font brandsIcon: ({
            family: fontAwesomeBrands.name
        })
        property font classicIcon: ({
            family: materialSymbolsRounded.name,
            pixelSize: 35
        })
    }
    fonts: QtObject {
        property string text: rubik.name
        property string brandIcon: fontAwesomeBrands.name
        property string icon: materialSymbolsRounded.name
    }
    fontSizes: QtObject {

    }

    FontLoader {
        id: rubik
        source: "../fonts/Rubik/Rubik-VariableFont_wght.ttf"
    }
    FontLoader {
        id: materialSymbolsRounded
        source: "../fonts/Material_Symbols_Rounded/MaterialSymbolsRounded-VariableFont_FILL,GRAD,opsz,wght.ttf"
    }
    FontLoader {
        id: fontAwesomeBrands
        source: "../fonts/FontAwesome7/otfs/Font Awesome 7 Brands-Regular-400.otf"
    }
}