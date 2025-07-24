import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: root
    width: 140
    height: 40
    text: "Download"

    background: Rectangle {
        radius: 8  // Rounded corners
        color: root.down ? "#cccccc" : "#e0e0e0"  // Change on press
        border.color: "#999999"
        border.width: 1
    }

    contentItem: Text {
        text: root.text
        anchors.centerIn: parent
        font: root.font
        color: "black"
    }
}
