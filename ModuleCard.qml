import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: moduleCard
    width: parent.width
    height: Math.max(80, contentLayout.implicitHeight + 16)
    radius: 12
    color: hovered ? "#252525" : "#1a1a1a"
    border.color: "#2a2a2a"
    border.width: 1

    property var module
    property string moduleName: module?.name || "Unnamed expansion pack"
    property string moduleDescription: module?.description || "No description available"
    property string logoUrl: module?.logo || ""
    property int originalPrice: module?.priceCurrent || 0
    property string purchase: module?.purchase || ""

    property string formattedPrice: originalPrice > 0 ?
        "$" + (originalPrice / 100).toFixed(2) : "Free"

    property bool hovered: false

    MouseArea {
        id: cardMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: parent.hovered = true
        onExited: parent.hovered = false
        cursorShape: Qt.PointingHandCursor
    }

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    RowLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        Rectangle {
            id: logoContainer
            Layout.preferredWidth: 56
            Layout.preferredHeight: 56
            Layout.alignment: Qt.AlignTop
            radius: 8
            color: "#333333"
            border.color: "#444444"
            border.width: 1

            Image {
                id: logoImage
                anchors.fill: parent
                anchors.margins: 4
                source: logoUrl
                fillMode: Image.PreserveAspectFit
                visible: logoUrl !== ""

                onStatusChanged: {
                    if (status === Image.Error) {
                        visible = false
                        fallbackIcon.visible = true
                    }
                }
            }

            Text {
                id: fallbackIcon
                anchors.centerIn: parent
                text: "📦"
                font.pixelSize: 24
                visible: logoUrl === "" || logoImage.status === Image.Error
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop
            spacing: 6

            Text {
                id: nameText
                Layout.fillWidth: true
                text: moduleName
                color: "white"
                font.pixelSize: 16
                font.weight: Font.Medium
                elide: Text.ElideRight
                maximumLineCount: 1
                wrapMode: Text.NoWrap
            }

            Text {
                id: descriptionText
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: moduleDescription
                color: "#cccccc"
                font.pixelSize: 13
                elide: Text.ElideRight
                maximumLineCount: 2
                wrapMode: Text.WordWrap
                lineHeight: 1.2
            }
        }

        Button {
            id: priceButton
            Layout.preferredWidth: Math.max(80, implicitWidth)
            Layout.preferredHeight: 36
            Layout.alignment: Qt.AlignVCenter

            text: formattedPrice

            background: Rectangle {
                radius: 6
                color: priceButton.pressed ? "#0066cc" :
                       priceButton.hovered ? "#0077dd" : "#0088ff"
                border.color: priceButton.pressed ? "#0055bb" : "#0088ff"
                border.width: 1

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            contentItem: Text {
                text: priceButton.text
                color: "white"
                font.pixelSize: 13
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                if (purchase !== "") {
                    Qt.openUrlExternally(purchase)
                } else {
                    console.log("No purchase link available")
                }
            }

            enabled: purchase !== ""
            opacity: enabled ? 1.0 : 0.6
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 1
        radius: parent.radius
        color: "transparent"
        border.color: "#ffffff08"
        border.width: 1
        z: -1
    }
}
