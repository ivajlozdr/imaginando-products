import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    visible: controller.loading
    anchors.fill: parent
    z: 999

    Rectangle {
        anchors.centerIn: parent
        width: 300
        height: 100
        color: "#222"
        radius: 12
        border.color: "#444"
        border.width: 1

        Column {
            anchors.centerIn: parent
            spacing: 12

            Text {
                text: "Downloading..."
                color: "white"
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ProgressBar {
                value: controller.downloadProgress
                width: 250
            }
        }
    }
}

