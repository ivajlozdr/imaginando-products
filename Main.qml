import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "Product Viewer"

    Rectangle {
        id: background
        anchors.fill: parent
        color: "white"
    }

    Image {
        id: mainLogo
        source: "qrc:/logo_imaginando.jpeg"
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
        target: backend
        function onDataReady(data) {
            jsonModel.clear();
            for (let i = 0; i < data.length; ++i) {
                jsonModel.append(data[i]);
            }
        }
    }

    ScrollView {
            anchors.fill: parent
            anchors.topMargin: 100
            anchors.leftMargin: 10
            anchors.rightMargin: 10

            ListView {
                anchors.fill: parent
                model: jsonModel
                spacing: 10
                clip: true
                boundsBehavior: Flickable.DragAndOvershootBounds
                snapMode: ListView.SnapToItem

                delegate: Row {
                    width: parent.width
                    spacing: 16

                    Column {
                        height: 200
                        width: 200
                        Image {
                            source: model.cover
                            width: 200
                            height: 100
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                    Column {
                        width: parent.width - 350
                        anchors.leftMargin: 200

                        spacing: 4

                        Text {
                            text: model.name ?? "No name"
                            font.family: "Poppins"
                            font.bold: true
                            font.pointSize: 14
                        }

                        Text {
                            text: model.webpage ?? "No link"
                            font.family: "Poppins"
                            color: "gray"
                            font.italic: true
                        }

                        Rectangle {
                            height: 1
                            width: parent.width
                            color: "#cccccc"
                        }
                    }

                    Column {
                        width: 150
                        Button {
                            font.family: "Poppins"
                            text: "Download"
                            onClicked: {
                                Qt.openUrlExternally(model.webpage)
                            }
                        }
                    }
                }

        }
    }

}
