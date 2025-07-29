import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: parent.width

    property alias icon: iconSource.source
    property alias label: labelText.text

    property bool expandable: false
    property bool expanded: false

    property string contentText: ""
    property Component contentItem: null

    property int baseHeight: 60

    property int contentHeight: contentItemLoader.item ? contentItemLoader.item.implicitHeight + 40
                                                       : (contentText.length > 0 ? textItem.implicitHeight + 40 : 0)

    property int internalHeight: baseHeight
    height: internalHeight

    states: [
        State {
            name: "expanded"
            when: expandable && expanded
            PropertyChanges { target: root; internalHeight: baseHeight + contentHeight }
        },
        State {
            name: "collapsed"
            when: !expanded
            PropertyChanges { target: root; internalHeight: baseHeight }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { properties: "internalHeight"; duration: 250; easing.type: Easing.OutCubic }
        }
    ]

    Rectangle {
        id: headerRect
        width: root.width
        height: baseHeight
        color: mouseArea.containsMouse ? "#404040" : "transparent"

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: if (expandable) expanded = !expanded
        }

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            spacing: 15

            Image {
                id: iconSource
                width: 20
                height: 20
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: labelText
                font.pixelSize: 14
                font.weight: Font.Medium
                color: "#FAFAFA"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Text {
            text: expandable ? (expanded ? "▼" : "▶") : ""
            font.pixelSize: 12
            color: "#FAFAFA"
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Rectangle {
        id: dropdownBox
        width: root.width
        height: expanded ? contentHeight : 0
        color: "#333239"
        anchors.top: headerRect.bottom
        clip: true
        visible: expandable

        Behavior on height {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
        }

        Loader {
            id: contentItemLoader
            anchors.fill: parent
            sourceComponent: contentItem
            visible: contentItem !== null && expanded
            opacity: expanded ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }
        }

        // fallback to text if no component given
        Text {
            id: textItem
            visible: contentItem === null && contentText.length > 0 && expanded
            text: contentText
            anchors.margins: 20
            anchors.fill: parent
            wrapMode: Text.WordWrap
            font.pixelSize: 11
            color: "#FAFAFA"
            opacity: expanded ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }
        }
    }
}
