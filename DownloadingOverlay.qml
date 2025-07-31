import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/*

warning: this shucks nuts

it only tracks the download progress of the archive.

no unzipping progress (cus powershell sucks, use an actual decompression library for that)

kills itself right after installer has launched cause i have no idea how to
implement a progress tracker for the installer progress.

see controller.cpp for install() and launchInstaller()

*/
Item {
    visible: controller.loading
    anchors.fill: parent
    z: 999

    Rectangle {
        anchors.fill: parent
        color: "#80000000"
        opacity: 0.8

        MouseArea {
            anchors.fill: parent
            onClicked: {
                // empty so no clicks go thru
            }
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: 320
        height: 140
        color: "#2a2a2a"
        radius: 16
        border.color: "#555"
        border.width: 1

        Rectangle {
            anchors.fill: parent
            anchors.margins: 2
            color: "transparent"
            radius: parent.radius
            border.color: "#666"
            border.width: 1
            opacity: 0.3
        }

        Column {
            anchors.centerIn: parent
            spacing: 20
            width: parent.width - 40

            Text {
                text: controller.downloadProgress >= 1.0 ? "Installing..." : "Downloading..."
                color: "#ffffff"
                font.pixelSize: 18
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ProgressBar {
                id: progressBar
                visible: controller.downloadProgress < 1.0
                value: controller.downloadProgress
                width: parent.width
                height: 8

                background: Rectangle {
                    implicitWidth: 200
                    implicitHeight: 8
                    color: "#404040"
                    radius: 4
                }

                contentItem: Item {
                    implicitWidth: 200
                    implicitHeight: 8

                    Rectangle {
                        width: progressBar.visualPosition * parent.width
                        height: parent.height
                        radius: 4
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#4CAF50" }
                            GradientStop { position: 1.0; color: "#45a049" }
                        }
                    }
                }
            }

            Item {
                visible: controller.downloadProgress >= 1.0
                width: 24
                height: 24
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    id: spinner
                    width: 20
                    height: 20
                    anchors.centerIn: parent
                    color: "transparent"
                    border.color: "#4CAF50"
                    border.width: 2
                    radius: 10

                    Rectangle {
                        width: 6
                        height: 6
                        radius: 3
                        color: "#4CAF50"
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: 2
                    }

                    RotationAnimation {
                        target: spinner
                        property: "rotation"
                        from: 0
                        to: 360
                        duration: 1000
                        loops: Animation.Infinite
                        running: controller.downloadProgress >= 1.0
                    }
                }
            }
        }
    }
}
