import QtQuick
import QtQuick.Layouts
import QtQuick.Controls


/*

simply a dummy

putting here the settings which i think are a must-have (or cool)

todo: make it work

*/
Item {
    width: parent.width
    implicitHeight: column.implicitHeight

    Column {
        id: column
        spacing: 24
        anchors.margins: 24
        anchors.fill: parent

        Column {
            width: parent.width
            spacing: 12

            // main stuff
            Text {
                text: "Download Settings"
                color: "#FFFFFF"
                font.pixelSize: 14
                font.weight: Font.Medium
            }

            Column {
                width: parent.width
                spacing: 8

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

            Row {
                spacing: 8
                CheckBox {
                    id: customiseCheck
                    checked: false
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        x: customiseCheck.leftPadding
                        y: parent.height / 2 - height / 2
                        radius: 2
                        color: customiseCheck.checked ? "#FAFAFA" : "transparent"
                        border.color: "#CCCCCC"
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: "✓"
                            color: "#000000"
                            font.pixelSize: 10
                            visible: customiseCheck.checked
                        }
                    }
                }
                /*

                this probably needs an info box or something.
                something to tell the user - this makes it so the installer is
                fully visible during download and you can manually configure everything

                !! This should change the *verbosity* level when calling Controller::launchInstaller()

                VERBOSITY=3

                */
                Text {
                    text: "Customise Install"
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#CCCCCC"
                    font.pixelSize: 12
                }
            }

            Row {
                spacing: 8
                CheckBox {
                    id: showInstallerCheck
                    checked: false
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        x: showInstallerCheck.leftPadding
                        y: parent.height / 2 - height / 2
                        radius: 2
                        color: showInstallerCheck.checked ? "#FAFAFA" : "transparent"
                        border.color: "#CCCCCC"
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: "✓"
                            color: "#000000"
                            font.pixelSize: 10
                            visible: showInstallerCheck.checked
                        }
                    }
                }
                /*

                this probably needs an info box or something.
                something to tell the user - this makes it so the installer is
                visible during download, but you cannot touch any settings.

                !! This should change the *verbosity* level when calling Controller::launchInstaller()

                VERBOSITY=2

                */
                Text {
                    text: "Visible Installer"
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#CCCCCC"
                    font.pixelSize: 12
                }
            }

            Row {
                spacing: 8
                CheckBox {
                    id: silentCheck
                    checked: true
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        x: silentCheck.leftPadding
                        y: parent.height / 2 - height / 2
                        radius: 2
                        color: silentCheck.checked ? "#FAFAFA" : "transparent"
                        border.color: "#CCCCCC"
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: "✓"
                            color: "#000000"
                            font.pixelSize: 10
                            visible: silentCheck.checked
                        }
                    }
                }
                /*

                this probably needs an info box or something.
                something to tell the user - this makes it so the installer is
                NOT visible during download, but you cannot touch any settings.

                !! This should change the *verbosity* level when calling Controller::launchInstaller()

                VERBOSITY=1

                */
                Text {
                    text: "Silent Install"
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#CCCCCC"
                    font.pixelSize: 12
                }
            }
        }

        // appearance - could be cool
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

        // basic actions
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

            // maybe cool, iunno
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
