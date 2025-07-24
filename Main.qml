import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import App 1.0

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "Product Viewer"

    Rectangle {
        id: background
        anchors.fill: parent
        color: Styles.mainBG
    }

    Image {
        id: mainLogo
        source: "qrc:/logo_imaginando.png"
        width: 200
        height: 45
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
    }

    ListModel {
        id: jsonModel
    }

    Connections {
        target: controller

        function onDataReady(data) {
            jsonModel.clear()
            for (var i = 0; i < data.length; ++i) {
                jsonModel.append(data[i])
            }
        }
    }

    ScrollView {
        anchors.fill: parent
        anchors.topMargin: 80

        ListView {
            anchors.fill: parent
            model: jsonModel
            clip: true
            boundsBehavior: Flickable.DragAndOvershootBounds
            snapMode: ListView.SnapToItem
            delegate: Rectangle {
                width: parent.width
                height: contentItem.implicitHeight + 20
                radius: 4
                border.color: "#00000000"
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: Qt.darker(model.colorPrimary, 5.0)
                    }
                    GradientStop {
                        position: 0.1
                        color: Qt.darker(model.colorPrimary, 6.0)
                    }
                    GradientStop {
                        position: 0.4
                        color: Qt.darker(model.colorPrimary, 8.0)
                    }
                    GradientStop {
                        position: 1.0
                        color: "#000000"
                    }
                }

                Row {
                    id: contentItem
                    width: parent.width
                    anchors.margins: 20
                    spacing: 10

                    Rectangle { // Left spacer
                        width: 20
                        height: 1
                        color: "transparent"
                    }

                    Column {
                        anchors.leftMargin: 10
                        Image {
                            source: model.logo
                            width: 180
                            height: 180
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                    Column {
                        width: parent.width - 400
                        anchors.leftMargin: 220
                        spacing: 4

                        Text {
                            text: model.name ?? "No name"
                            font: Styles.titleFont
                        }

                        Text {
                            text: model.webpage ?? "No link"
                            font: Styles.subtitleFont
                        }
                    }

                    Item {
                        width: 100
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 5

                        DownloadButton {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            onClicked: Qt.openUrlExternally(model.download)
                            font: Styles.buttonTxt
                        }
                    }
                }

                Rectangle {
                    height: 1
                    width: parent.width
                    anchors.bottom: parent.bottom
                    color: "black"
                }
            }
        }
    }
}
