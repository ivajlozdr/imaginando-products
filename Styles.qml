pragma Singleton
import QtQuick 2.15
import QtQuick.Controls 2.15

QtObject {
    readonly property color mainBG: "#181818"
    readonly property color cardBG: "#ffffff"
    readonly property color textPrimary: "#333333"
    readonly property color textSecondary: "#666666"
    readonly property color accent: "#007acc"

    readonly property font titleFont: Qt.font({ family: "Poppins", pointSize: 20, bold: true })
    readonly property font subtitleFont: Qt.font({ family: "Poppins", pointSize: 15, italic: true })
    readonly property font buttonTxt: Qt.font({ family: "Poppins", pointSize: 15, italic: true })

    readonly property int spacingXS: 4
    readonly property int spacingS: 8
    readonly property int spacingM: 16
    readonly property int spacingL: 24
    readonly property int spacingXL: 32

    readonly property int breakpointSmall: 600
    readonly property int breakpointMedium: 900
    readonly property int breakpointLarge: 1200
}
