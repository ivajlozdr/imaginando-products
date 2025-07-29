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

        Column {
            width: parent.width
            spacing: 8

            TextField {
                id: emailField
                placeholderText: "email"
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
        }

        Column {
            width: parent.width
            spacing: 8

            TextField {
                id: passwordField
                placeholderText: "password"
                echoMode: showPassword.checked ? TextInput.Normal : TextInput.Password
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

                    contentItem: Image {
                        source: "qrc:/copy.svg"
                    }

                    onClicked: {
                        if (passwordField.text.length > 0) {
                            // TODO: make it work :)
                            console.log("password copy logic not implemented yet lul")
                        }
                    }
                }
            }
        }

        Row {
            spacing: 8
            anchors.right: parent.right

            CheckBox {
                id: showPassword

                indicator: Rectangle {
                    implicitWidth: 16
                    implicitHeight: 16
                    x: showPassword.leftPadding
                    y: parent.height / 2 - height / 2
                    radius: 2
                    color: showPassword.checked ? "#FAFAFA" : "transparent"
                    border.color: "#CCCCCC"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "✓"
                        color: "#000000"
                        font.pixelSize: 10
                        visible: showPassword.checked
                    }
                }
            }

            Text {
                text: "Show password"
                anchors.verticalCenter: parent.verticalCenter
                color: "#CCCCCC"
                font.pixelSize: 12
            }
        }
        Row {
            spacing: 16
            width: parent.width

            Button {
                text: "RECOVER"

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
                    // TODO: make it work :)
                    console.log("recovery also not implemented")
                }
            }

            Item {
                Layout.fillWidth: true
                width: 1
            }

            Button {
                text: "SIGNUP"

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
                    // TODO: make it work :)
                    console.log("sign up neither!")
                }
            }

            Button {
                text: "LOGIN"

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
                    // TODO: make it work :)
                    console.log("yeah, no")
                }
            }
        }
    }
}
