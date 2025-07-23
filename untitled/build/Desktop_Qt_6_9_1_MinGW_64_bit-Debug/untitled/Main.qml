import QtQuick

Window {
    width: 1000
    height: 600
    visible: true
    title: qsTr("Hello World")

    // Rectangle {
    //     id: listViewContainer
    //     width: 900
    //     height: 300
    // }

    Image {
        id: logo
        source: "qrc:/logo_imaginando.jpeg"
        width: 100
        height: 100
    }
}

