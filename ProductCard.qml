import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: cardRoot

    // Properties
    property int cardMargin: 20
    property int cardRadius: 12
    property string currentBreakpoint: "medium"

    // Model data properties
    property string productName: ""
    property string productWebpage: ""
    property string productLogo: ""
    property string productDownload: ""
    property color productColorPrimary: "#333333"

    // Responsive dimensions
    readonly property int cardHeight: currentBreakpoint === "small" ? 180 : 220
    readonly property int imageSize: currentBreakpoint === "small" ? 80 : 120
    readonly property int contentSpacing: currentBreakpoint === "small" ? 12 : 16
    readonly property int textSpacing: currentBreakpoint === "small" ? 4 : 8

    width: parent.width
    height: cardHeight + 20 // Extra space for shadow

    Rectangle {
        id: cardBackground
        width: parent.width
        height: cardHeight
        radius: cardRadius
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        // Enhanced gradient
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

        // Subtle shadow effect
        layer.enabled: true
        scale: cardMouseArea.containsMouse ? 1.02 : 1.0
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

            // Product image with error handling
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
                    source: logo
                    fillMode: Image.PreserveAspectFit

                    // Critical: Prevent image disappearing
                    cache: true
                    asynchronous: true

                    // Smooth scaling
                    smooth: true
                    mipmap: true

                    onStatusChanged: {
                        if (status === Image.Error) {
                            console.warn("Failed to load product image:", productLogo)
                        }
                    }

                    // Ensure image stays loaded
                    Component.onCompleted: {
                        if (source.toString().length > 0) {
                            // Force reload if needed
                            var temp = source
                            source = ""
                            source = temp
                        }
                    }
                }
            }

            // Content area
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

            // Download button area
            Item {
                Layout.preferredWidth: currentBreakpoint === "small" ? 80 : 100
                Layout.alignment: Qt.AlignVCenter

                DownloadButton {
                    id: downloadBtn
                    anchors.centerIn: parent
                    font: Styles.buttonTxt

                    // Responsive sizing
                    width: currentBreakpoint === "small" ? 70 : 90
                    height: currentBreakpoint === "small" ? 32 : 36

                    onClicked: {
                        if (productDownload.length > 0) {
                            Qt.openUrlExternally(productDownload)
                        }
                    }
                }
            }
        }

        // Bottom border
        Rectangle {
            height: 1
            width: parent.width - (contentSpacing * 2)
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: contentSpacing
            color: "#ffffff20"
        }

        // Mouse area for hover effects
        MouseArea {
            id: cardMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                if (productWebpage.length > 0) {
                    Qt.openUrlExternally(productWebpage)
                }
            }
        }
    }
}
