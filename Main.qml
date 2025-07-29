import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

ApplicationWindow {
    id: root
    visible: true
    width: 800
    height: 600
    minimumWidth: 400
    minimumHeight: 300
    title: "Imaginando Product Panel"

    readonly property int breakpointSmall: 600
    readonly property int breakpointMedium: 900
    readonly property int breakpointLarge: 1200

    readonly property string currentBreakpoint: {
        if (width < breakpointSmall) return "small"
        else if (width < breakpointMedium) return "medium"
        else if (width < breakpointLarge) return "large"
        else return "xlarge"
    }

    readonly property int cardMargin: currentBreakpoint === "small" ? 5 : 8
    readonly property int cardSpacing: currentBreakpoint === "small" ? 5 : 8
    readonly property int cardRadius: 12
    readonly property int logoWidth: Math.min(200, width * 0.25)
    readonly property int logoHeight: logoWidth * 0.225

    Rectangle {
        id: background
        anchors.fill: parent
        color: Styles.mainBG
    }

    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: logoHeight + (cardMargin * 2)
        color: "transparent"

        Image {
            id: mainLogo
            source: "qrc:/logo_imaginando.png"
            width: logoWidth
            height: logoHeight
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit

            cache: true
            asynchronous: true

            onStatusChanged: {
                if (status === Image.Error) {
                    console.warn("Failed to load logo image")
                }
            }
        }
    }

    ScrollView {
        id: scrollView
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 0

        ScrollBar.vertical.policy: ScrollBar.AsNeeded
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        clip: true

        ListView {
            id: listView
            anchors.fill: parent
            anchors.leftMargin: cardMargin
            anchors.rightMargin: cardMargin

            model: controller.model
            spacing: cardSpacing
            clip: true

            cacheBuffer: height > 0 ? height * 2 : 200
            reuseItems: true

            topMargin: cardSpacing
            bottomMargin: cardSpacing

            delegate: ProductCard {
                width: listView.width
                cardMargin: root.cardMargin
                cardRadius: root.cardRadius
                currentBreakpoint: root.currentBreakpoint
                onHeightChanged: listView.forceLayout()

                productName: model.name || "No name"
                productWebpage: model.webpage || "No link"
                productLogo: model.logo || ""
                productDownload: model.download || ""
                productColorPrimary: model.colorPrimary || "#333333"
                productModules: model.modules
            }
            flickDeceleration: 1500
            maximumFlickVelocity: 2500
        }
    }
}
