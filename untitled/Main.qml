import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "Product Viewer"

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

    ListView {
        anchors.fill: parent
        model: jsonModel
        spacing: 10
        delegate: Column {
            width: parent.width
            spacing: 8

            Image {
                source: model.cover
                width: 200
                height: 100
                fillMode: Image.PreserveAspectFit
            }

            Text {
                text: model.name ?? "No name"
                font.bold: true
                font.pointSize: 14
            }

            Text {
                text: model.webpage ?? "No link"
                color: "blue"
                font.italic: true
            }

            Rectangle {
                height: 1
                width: parent.width
                color: "#cccccc"
            }
        }
    }
}
