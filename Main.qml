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

    property bool sidebarOpen: false
    readonly property int sidebarWidth: 280

    Rectangle {
        id: background
        anchors.fill: parent
        color: Styles.mainBG
    }

    Rectangle {
        id: sidebarOverlay
        anchors.fill: parent
        color: "#80000000"
        opacity: sidebarOpen ? 1 : 0
        visible: opacity > 0
        z: 10

        Behavior on opacity {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.sidebarOpen = false
        }
    }

    Rectangle {
        id: sidebar
        width: sidebarWidth
        height: parent.height
        x: sidebarOpen ? 0 : -width
        z: 11
        color: "#222126"

        Behavior on x {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
        }

        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            spacing: 0

            Repeater {
                model: [
                    { icon: "qrc:/profile.svg", text: "PROFILE" },
                    { icon: "qrc:/store.svg", text: "STORE" },
                    { icon: "qrc:/about.svg", text: "ABOUT" },
                    { icon: "qrc:/help.svg", text: "HELP" }
                ]

                delegate: Rectangle {
                    width: sidebar.width
                    height: 60
                    color: mouseArea.containsMouse ? "#404040" : "transparent"

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            console.log("Clicked:", modelData.text)
                            // logic to be done lol
                        }
                    }

                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 15

                        Image {
                            id: sidebarSectionIcon
                            source: modelData.icon
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: modelData.text
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: "#ffffff"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }

        Rectangle {
            width: sidebar.width
            height: sidebarLogo.height + 10
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            color: "transparent"

            Image {
                id: sidebarLogo
                source: "qrc:/logo_sidebar.png"
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.bottomMargin: 5
                anchors.leftMargin: 5
            }
        }

    }

    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: logoHeight + (cardMargin * 2)
        color: "#222126"

        Button {
            id: menuButton
            width: 40
            height: 40
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter

            background: Rectangle {
                color: "transparent"
                radius: 6
            }

            contentItem: Item {
                anchors.fill: parent
                Column {
                    anchors.centerIn: parent
                    spacing: 3

                    Repeater {
                        model: 3
                        Rectangle {
                            width: 20
                            height: 2
                            color: "#ffffff"
                            radius: 1
                        }
                    }
                }
            }

            onClicked: root.sidebarOpen = !root.sidebarOpen
        }

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
