import QtQuick 2.15
import QtQuick.Controls 2.15
import App 1.0

Button {
    id: root
    width: 140
    height: 40

    background: Rectangle {
        radius: height / 2
        color: "black"
    }

    contentItem: Text {
        text: root.text
        anchors.centerIn: parent
        font: root.font
        color: "red"
    }
}
