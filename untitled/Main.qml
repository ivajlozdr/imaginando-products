import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 600
    height: 400
    title: "JSON Viewer"

    ListView {
        anchors.fill: parent
        model: jsonModel

        delegate: Rectangle {
            height: 50
            width: parent.width
            border.color: "#888"
            color: "white"

            Text {
                anchors.centerIn: parent
                text: modelData.name
                color: "black"
            }
        }
    }

    ListModel {
        id: jsonModel
    }

    Connections {
        target: backend
        function onDataReady(data) {
            jsonModel.clear()
            for (let i = 0; i < data.length; ++i) {
                let item = data[i];
                jsonModel.append({ "name": item.name });
            }
        }
    }
}
