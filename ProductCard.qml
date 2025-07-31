import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: cardRoot

    property int cardMargin: 20
    property int cardRadius: 16
    property string currentBreakpoint: "medium"
    property var productModules
    property string productName: ""
    property string productWebpage: ""
    property string productLogo: ""
    property string productDownload: ""
    property color productColorPrimary: "#333333"
    property bool modulesExpanded: false
    property int baseHeight: currentBreakpoint === "small" ? 180 : 220

    readonly property int imageSize: currentBreakpoint === "small" ? 80 : 120
    readonly property int contentSpacing: currentBreakpoint === "small" ? 16 : 20
    readonly property int textSpacing: currentBreakpoint === "small" ? 6 : 8

    width: parent.width
    height: baseHeight + (modulesExpanded ? modulesSection.implicitHeight + 20 : 0)

    Rectangle {
        id: cardShadow
        width: cardBackground.width
        height: cardBackground.height
        radius: cardBackground.radius
        anchors.centerIn: cardBackground
        anchors.verticalCenterOffset: 2
        color: "#00000040"
        z: -1
    }

    Rectangle {
        id: cardBackground
        width: parent.width
        height: baseHeight
        radius: cardRadius
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {
                position: 0.0
                color: Qt.darker(productColorPrimary, 2)
            }
            GradientStop {
                position: 0.4
                color: Qt.darker(productColorPrimary, 4.0)
            }
            GradientStop {
                position: 0.6
                color: Qt.darker(productColorPrimary, 6.0)
            }
            GradientStop {
                position: 0.75
                color: Qt.darker(productColorPrimary, 10)
            }
            GradientStop {
                position: 1.0
                color: "#0a0a0a"
            }
        }

        border.color: "#333333"
        border.width: 1

        Behavior on scale {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: contentSpacing
            spacing: contentSpacing

            Item {
                Layout.preferredWidth: imageSize
                Layout.preferredHeight: imageSize
                Layout.alignment: Qt.AlignVCenter

                Rectangle {
                    id: imageContainer
                    anchors.fill: parent
                    radius: 12
                    color: "#333333"

                    Rectangle {
                        id: imagePlaceholder
                        anchors.fill: parent
                        radius: parent.radius
                        color: "#333333"
                        visible: productImage.status !== Image.Ready

                        Text {
                            anchors.centerIn: parent
                            text: "📦"
                            color: "#333333"
                            font.pixelSize: imageSize * 0.3
                        }
                    }

                    Image {
                        id: productImage
                        anchors.fill: parent
                        anchors.margins: 8
                        source: productLogo
                        fillMode: Image.PreserveAspectFit
                        cache: true
                        smooth: true
                        mipmap: true

                        onStatusChanged: {
                            if (status === Image.Error) {
                                console.warn("Failed to load product image:", productLogo)
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignVCenter
                spacing: textSpacing

                Text {
                    id: nameText
                    text: productName
                    font.pixelSize: currentBreakpoint === "small" ? 18 : 22
                    font.weight: Font.Bold
                    color: "white"
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Text {
                    id: webpageText
                    text: productWebpage
                    font.pixelSize: currentBreakpoint === "small" ? 12 : 14
                    font.weight: Font.Normal
                    color: "#e0e0e0"
                    wrapMode: Text.WrapAnywhere
                    maximumLineCount: currentBreakpoint === "small" ? 1 : 2
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    opacity: 0.9
                }
            }

            Item {
                Layout.preferredWidth: currentBreakpoint === "small" ? 140 : 160
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignVCenter

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 12

                    Button {
                        id: downloadBtn
                        text: "Download"
                        Layout.preferredWidth: currentBreakpoint === "small" ? 120 : 140
                        Layout.preferredHeight: currentBreakpoint === "small" ? 36 : 40
                        Layout.alignment: Qt.AlignHCenter

                        background: Rectangle {
                            radius: 8
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#4CAF50" }
                                GradientStop { position: 1.0; color: "#45a049" }
                            }
                            border.color: downloadBtn.pressed ? "#3d8b40" : "#4CAF50"
                            border.width: 1

                            Rectangle {
                                anchors.fill: parent
                                anchors.topMargin: 1
                                radius: parent.radius - 1
                                color: "transparent"
                                border.color: "#333333"
                                border.width: 1
                            }
                        }

                        contentItem: Text {
                            text: downloadBtn.text
                            font.pixelSize: currentBreakpoint === "small" ? 13 : 14
                            font.weight: Font.Medium
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        scale: pressed ? 0.95 : (hovered ? 1.05 : 1.0)

                        Behavior on scale {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutCubic
                            }
                        }

                        onClicked: {
                            if (productDownload.length > 0) {
                                controller.install(productDownload)
                            }
                        }
                    }

                    /*

                    This is fucked.

                    fucked fucked.

                    if you do not click each product card's module button IN ORDER,
                    it starts glitching out.

                    */
                    Button {
                        id: toggleModulesBtn
                        text: modulesExpanded ? "Hide Packs" : "Show Packs"
                        Layout.preferredWidth: currentBreakpoint === "small" ? 120 : 140
                        Layout.preferredHeight: currentBreakpoint === "small" ? 36 : 40
                        Layout.alignment: Qt.AlignHCenter

                        background: Rectangle {
                            radius: 8
                            gradient: Gradient {
                                GradientStop {
                                    position: 0.0
                                    color: modulesExpanded ? "#f44336" : "#2196F3"
                                }
                                GradientStop {
                                    position: 1.0
                                    color: modulesExpanded ? "#d32f2f" : "#1976D2"
                                }
                            }
                            border.color: modulesExpanded ? "#d32f2f" : "#1976D2"
                            border.width: 1

                            Behavior on gradient {
                                ColorAnimation {
                                    duration: 200
                                    easing.type: Easing.OutCubic
                                }
                            }

                            Rectangle {
                                anchors.fill: parent
                                anchors.topMargin: 1
                                radius: parent.radius - 1
                                color: "transparent"
                                border.color: "#333333"
                                border.width: 1
                            }
                        }

                        contentItem: Text {
                            text: toggleModulesBtn.text
                            font.pixelSize: currentBreakpoint === "small" ? 13 : 14
                            font.weight: Font.Medium
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        scale: pressed ? 0.95 : (hovered ? 1.05 : 1.0)

                        Behavior on scale {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutCubic
                            }
                        }

                        onClicked: {
                            modulesExpanded = !modulesExpanded
                        }
                    }
                }
            }
        }
    }

    ColumnLayout {
        id: modulesSection
        anchors.top: cardBackground.bottom
        anchors.left: cardBackground.left
        anchors.right: cardBackground.right
        visible: modulesExpanded
        opacity: modulesExpanded ? 1 : 0
        spacing: 10
        anchors.margins: cardMargin

        Behavior on opacity {
                   NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }

        Repeater {
            model: productModules
            ModuleCard {
                module: modelData

            }
        }
    }
}
