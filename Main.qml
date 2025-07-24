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
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        ListView {
            anchors.fill: parent
            model: jsonModel
            spacing: 10
            clip: true
            boundsBehavior: Flickable.DragAndOvershootBounds
            snapMode: ListView.SnapToItem
            delegate: Rectangle {
                width: parent.width
                height: contentItem.implicitHeight + 20
                color: Qt.darker(
                           model.color_primary,
                           2.0)
                radius: 4

                Row {
                    id: contentItem
                    width: parent.width
                    anchors.margins: 10
                    spacing: 16

                    Column {
                        height: 200
                        width: 200
                        Image {
                            source: model.logo
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
                            font: Styles.titleFont
                        }

                        Text {
                            text: model.webpage ?? "No link"
                            font: Styles.subtitleFont
                        }
                    }

                    Column {
                        width: 150
                        DownloadButton {
                            text: "Download"
                            onClicked: Qt.openUrlExternally(model.download)
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
