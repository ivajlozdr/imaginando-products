import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: overlay
    visible: controller.loading
    anchors.fill: parent
    z: 999

    Rectangle {
        anchors.fill: parent
        color: "#AA000000"
    }

    Column {
        spacing: 12
        anchors.centerIn: parent
        width: 120

        BusyIndicator {
            running: true
            width: 40
            height: 40
        }

        Text {
            text: "Installing..."
            color: "white"
            font.pixelSize: 16
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
        }
    }
}
