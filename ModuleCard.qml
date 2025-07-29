import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

Rectangle {
    id: moduleCard
    width: parent.width
    height: Math.max(88, contentLayout.implicitHeight + 20)
    radius: 14

    color: hovered ? "#2a2a2a" : "#1e1e1e"
    border.color: hovered ? "#3a3a3a" : "#2a2a2a"
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
    property bool pressed: false

    Rectangle {
        id: cardShadow
        anchors.fill: parent
        anchors.topMargin: 2
        radius: parent.radius
        color: "#00000030"
        z: -2
        opacity: hovered ? 0.6 : 0.3

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    MouseArea {
        id: cardMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: parent.hovered = true
        onExited: parent.hovered = false
        onPressed: parent.pressed = true
        onReleased: parent.pressed = false
        cursorShape: Qt.PointingHandCursor
    }

    Behavior on color {
        ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    Behavior on border.color {
        ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    scale: pressed ? 0.98 : (hovered ? 1.02 : 1.0)

    Behavior on scale {
        NumberAnimation {
            duration: 150
            easing.type: Easing.OutCubic
        }
    }

    RowLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        Rectangle {
            id: logoContainer
            Layout.preferredWidth: 64
            Layout.preferredHeight: 64
            Layout.alignment: Qt.AlignVCenter
            radius: 12

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#404040" }
                GradientStop { position: 1.0; color: "#2a2a2a" }
            }

            border.color: "#505050"
            border.width: 1

            Image {
                id: logoImage
                anchors.fill: parent
                anchors.margins: 6
                source: logoUrl
                fillMode: Image.PreserveAspectFit
                visible: logoUrl !== "" && status === Image.Ready
                smooth: true
                mipmap: true

                onStatusChanged: {
                    if (status === Image.Error) {
                        console.warn("Failed to load module logo:", logoUrl)
                    }
                }
            }

            Text {
                id: fallbackIcon
                anchors.centerIn: parent
                text: "🎵"
                font.pixelSize: 28
                visible: logoUrl === "" || logoImage.status !== Image.Ready
                opacity: 0.7
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 8

            Text {
                id: nameText
                Layout.fillWidth: true
                text: moduleName
                color: "white"
                font.pixelSize: 17
                font.weight: Font.DemiBold
                elide: Text.ElideRight
                maximumLineCount: 1
                wrapMode: Text.NoWrap
            }

            Text {
                id: descriptionText
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: moduleDescription
                color: "#d0d0d0"
                font.pixelSize: 13
                font.weight: Font.Normal
                elide: Text.ElideRight
                maximumLineCount: 2
                wrapMode: Text.WordWrap
                lineHeight: 1.3
                opacity: 0.9
            }
        }

        Button {
            id: priceButton
            Layout.preferredWidth: Math.max(90, implicitWidth + 20)
            Layout.preferredHeight: 42
            Layout.alignment: Qt.AlignVCenter

            text: formattedPrice
            enabled: purchase !== ""

            background: Rectangle {
                radius: 10

                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: !priceButton.enabled ? "#666666" :
                               priceButton.pressed ? "#0056b3" :
                               priceButton.hovered ? "#007bff" :
                               originalPrice === 0 ? "#28a745" : "#007bff"
                    }
                    GradientStop {
                        position: 1.0
                        color: !priceButton.enabled ? "#555555" :
                               priceButton.pressed ? "#004085" :
                               priceButton.hovered ? "#0056b3" :
                               originalPrice === 0 ? "#1e7e34" : "#0056b3"
                    }
                }

                border.color: !priceButton.enabled ? "#555555" :
                             priceButton.pressed ? "#004085" :
                             originalPrice === 0 ? "#1e7e34" : "#0056b3"
                border.width: 1

                Rectangle {
                    anchors.fill: parent
                    anchors.topMargin: 1
                    radius: parent.radius - 1
                    color: "transparent"
                    border.color: priceButton.enabled ? "#ffffff20" : "transparent"
                    border.width: 1
                }

                Behavior on gradient {
                    ColorAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }
            }

            contentItem: Text {
                text: priceButton.text
                color: priceButton.enabled ? "white" : "#aaaaaa"
                font.pixelSize: 14
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            scale: pressed ? 0.95 : (hovered ? 1.05 : 1.0)
            opacity: enabled ? 1.0 : 0.6

            Behavior on scale {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }

            onClicked: {
                if (purchase !== "") {
                    clickAnimation.start()
                    Qt.openUrlExternally(purchase)
                } else {
                    console.log("No purchase link available")
                }
            }

            SequentialAnimation {
                id: clickAnimation
                NumberAnimation {
                    target: priceButton
                    property: "scale"
                    to: 0.9
                    duration: 50
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    target: priceButton
                    property: "scale"
                    to: 1.05
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
    Component.onCompleted: {
        opacity = 0
        scale = 0.8
        appearAnimation.start()
    }

    SequentialAnimation {
        id: appearAnimation
        ParallelAnimation {
            NumberAnimation {
                target: moduleCard
                property: "opacity"
                to: 1.0
                duration: 300
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: moduleCard
                property: "scale"
                to: 1.0
                duration: 300
                easing.type: Easing.OutBack
            }
        }
    }
}
