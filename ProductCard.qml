import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: cardRoot

    property int cardMargin: 20
    property int cardRadius: 12
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
    readonly property int contentSpacing: currentBreakpoint === "small" ? 12 : 16
    readonly property int textSpacing: currentBreakpoint === "small" ? 4 : 8

    width: parent.width
    height: baseHeight + (modulesExpanded ? modulesSection.implicitHeight : 0)
    Rectangle {
        id: cardBackground
        width: parent.width
        height: baseHeight
        radius: cardRadius
        anchors.horizontalCenter: parent.horizontalCenter
        // anchors.verticalCenter: parent.verticalCenter
        anchors.top: parent.top

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {
                position: 0.0
                color: Qt.darker(productColorPrimary, 3.0)
            }
            GradientStop {
                position: 0.4
                color: Qt.darker(productColorPrimary, 5.0)
            }
            GradientStop {
                position: 1.0
                color: "#000000"
            }
        }

        layer.enabled: true
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
                    id: imagePlaceholder
                    anchors.fill: parent
                    radius: 8
                    color: "#ffffff20"
                    border.color: "#ffffff40"
                    border.width: 1
                    visible: productImage.status !== Image.Ready

                    Text {
                        anchors.centerIn: parent
                        text: "No Image"
                        color: "#ffffff60"
                        font.pixelSize: 12
                    }
                }

                Image {
                    id: productImage
                    anchors.fill: parent
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

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: textSpacing

                Text {
                    id: nameText
                    text: productName
                    font: Styles.titleFont
                    color: "white"
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Text {
                    id: webpageText
                    text: productWebpage
                    font: Styles.subtitleFont
                    color: "#cccccc"
                    wrapMode: Text.WrapAnywhere
                    maximumLineCount: currentBreakpoint === "small" ? 1 : 2
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }
            Item {
                Layout.preferredWidth: currentBreakpoint === "small" ? 170 : 200
                Layout.alignment: Qt.AlignVCenter

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 0
                    spacing: 8

                    DownloadButton {
                        id: downloadBtn
                        text: "Download"
                        font: Styles.buttonTxt
                        Layout.preferredWidth: currentBreakpoint === "small" ? 70 : 90
                        Layout.preferredHeight: currentBreakpoint === "small" ? 32 : 36
                        Layout.alignment: Qt.AlignHCenter

                        onClicked: {
                            if (productDownload.length > 0) {
                                Qt.openUrlExternally(productDownload)
                            }
                        }
                    }

                    Button {
                        id: toggleModulesBtn
                        text: modulesExpanded ? "Hide Extension Packs" : "Show Extension Packs"
                        font: Styles.buttonTxt
                        Layout.preferredWidth: currentBreakpoint === "small" ? 70 : 90
                        Layout.preferredHeight: currentBreakpoint === "small" ? 32 : 36
                        Layout.alignment: Qt.AlignHCenter

                        onClicked: {
                            modulesExpanded = !modulesExpanded
                        }

                        background: Rectangle {
                            implicitWidth: 90
                            implicitHeight: 36
                            radius: 6
                            color: modulesExpanded ? "#cc3333" : "#33cc66"

                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                    easing.type: Easing.OutCubic
                                }
                            }

                            Rectangle {
                                anchors.fill: parent
                                radius: parent.radius
                                color: "transparent"
                            }
                        }

                        scale: pressed ? 0.95 : 1.0
                        Behavior on scale {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.OutCubic
                            }
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
