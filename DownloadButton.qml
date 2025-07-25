import QtQuick
import QtQuick.Controls

Button {
    id: control
    text: "Download"

    property color baseColor: "#007acc"
    property color hoverColor: "#0080ff"
    property color pressedColor: "#0066cc"

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 90
        implicitHeight: 36
        opacity: enabled ? 1 : 0.3
        radius: 6

        color: control.pressed ? pressedColor :
               control.hovered ? hoverColor : baseColor

        Behavior on color {
            ColorAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.color: control.pressed ? "#ffffff40" : "transparent"
            border.width: 1

            Behavior on border.color {
                ColorAnimation {
                    duration: 150
                }
            }
        }
    }

    scale: pressed ? 0.95 : 1.0
    Behavior on scale {
        NumberAnimation {
            duration: 100
            easing.type: Easing.OutCubic
        }
    }
}
