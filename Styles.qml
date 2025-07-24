pragma Singleton
import QtQuick 2.15
import QtQuick.Controls 2.15

QtObject {
    // Text Styles
    property font titleFont: Qt.font({ family: "Poppins", pointSize: 20, bold: true })
    property font subtitleFont: Qt.font({ family: "Poppins", pointSize: 15, italic: true })
    property font buttonFont: Qt.font({ family: "Poppins", pointSize: 10, italic: true })

    property color mainBG: "#181818"
}
