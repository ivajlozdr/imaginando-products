import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    width: parent.width
    implicitHeight: column.implicitHeight

    Column {
        id: column
        spacing: 24
        anchors.margins: 24
        anchors.fill: parent

        // General Settings Section
        Column {
            width: parent.width
            spacing: 12

            Text {
                text: "General"
                color: "#FFFFFF"
                font.pixelSize: 14
                font.weight: Font.Medium
            }

            Column {
                width: parent.width
                spacing: 8

                TextField {
                    id: usernameField
                    placeholderText: "username"
                    font.pixelSize: 14
                    width: parent.width
                    height: 40
                    background: Rectangle {
                        color: "transparent"
                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 1
                            color: "#FAFAFA"
                        }
                    }
                    color: "#FFFFFF"
                    placeholderTextColor: "#FAFAFA"
                    leftPadding: 0
                    rightPadding: 0
                    selectByMouse: true
                }

                TextField {
                    id: downloadPathField
                    placeholderText: "download path"
                    font.pixelSize: 14
                    width: parent.width
                    height: 40
                    background: Rectangle {
                        color: "transparent"
                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 1
                            color: "#FAFAFA"
                        }
                    }
                    color: "#FFFFFF"
                    placeholderTextColor: "#FAFAFA"
                    leftPadding: 0
                    rightPadding: 32
                    selectByMouse: true

                    Button {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        width: 24
                        height: 24
                        background: Rectangle {
                            color: "transparent"
                        }
                        contentItem: Text {
                            text: "📁"
                            font.pixelSize: 12
                            color: "#FAFAFA"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: {
                            console.log("browse folder dialog")
                        }
                    }
                }
            }
        }

        // Appearance Section
        Column {
            width: parent.width
            spacing: 12

            Text {
                text: "Appearance"
                color: "#FFFFFF"
                font.pixelSize: 14
                font.weight: Font.Medium
            }

            Row {
                spacing: 8
                CheckBox {
                    id: darkModeCheck
                    checked: true
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        x: darkModeCheck.leftPadding
                        y: parent.height / 2 - height / 2
                        radius: 2
                        color: darkModeCheck.checked ? "#FAFAFA" : "transparent"
                        border.color: "#CCCCCC"
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: "✓"
                            color: "#000000"
                            font.pixelSize: 10
                            visible: darkModeCheck.checked
                        }
                    }
                }
                Text {
                    text: "Dark mode"
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#CCCCCC"
                    font.pixelSize: 12
                }
            }

            Row {
                spacing: 8
                CheckBox {
                    id: minimizeToTrayCheck
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        x: minimizeToTrayCheck.leftPadding
                        y: parent.height / 2 - height / 2
                        radius: 2
                        color: minimizeToTrayCheck.checked ? "#FAFAFA" : "transparent"
                        border.color: "#CCCCCC"
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: "✓"
                            color: "#000000"
                            font.pixelSize: 10
                            visible: minimizeToTrayCheck.checked
                        }
                    }
                }
                Text {
                    text: "Minimize to tray"
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#CCCCCC"
                    font.pixelSize: 12
                }
            }
        }

        // Privacy Section
        Column {
            width: parent.width
            spacing: 12

            Text {
                text: "Privacy"
                color: "#FFFFFF"
                font.pixelSize: 14
                font.weight: Font.Medium
            }

            Row {
                spacing: 8
                CheckBox {
                    id: analyticsCheck
                    checked: true
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        x: analyticsCheck.leftPadding
                        y: parent.height / 2 - height / 2
                        radius: 2
                        color: analyticsCheck.checked ? "#FAFAFA" : "transparent"
                        border.color: "#CCCCCC"
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: "✓"
                            color: "#000000"
                            font.pixelSize: 10
                            visible: analyticsCheck.checked
                        }
                    }
                }
                Text {
                    text: "Send analytics"
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#CCCCCC"
                    font.pixelSize: 12
                }
            }

            Row {
                spacing: 8
                CheckBox {
                    id: crashReportsCheck
                    checked: true
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        x: crashReportsCheck.leftPadding
                        y: parent.height / 2 - height / 2
                        radius: 2
                        color: crashReportsCheck.checked ? "#FAFAFA" : "transparent"
                        border.color: "#CCCCCC"
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: "✓"
                            color: "#000000"
                            font.pixelSize: 10
                            visible: crashReportsCheck.checked
                        }
                    }
                }
                Text {
                    text: "Send crash reports"
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#CCCCCC"
                    font.pixelSize: 12
                }
            }
        }

        // Action Buttons
        Row {
            spacing: 16
            width: parent.width

            Button {
                text: "RESET"
                background: Rectangle {
                    color: parent.pressed ? "#444444" : (parent.hovered ? "#333333" : "#2A2A2A")
                    radius: 4
                }
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    console.log("reset settings")
                }
            }

            Item {
                Layout.fillWidth: true
                width: 1
            }

            Button {
                text: "EXPORT"
                background: Rectangle {
                    color: parent.pressed ? "#444444" : (parent.hovered ? "#333333" : "#2A2A2A")
                    radius: 4
                }
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    console.log("export settings")
                }
            }

            Button {
                text: "SAVE"
                background: Rectangle {
                    color: parent.pressed ? "#444444" : (parent.hovered ? "#333333" : "#2A2A2A")
                    radius: 4
                }
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    console.log("save settings")
                }
            }
        }
    }
}
