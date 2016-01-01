import QtQuick 2.4

Item {
    signal play

    anchors.fill: parent    

    Column {
        id: menu
        anchors.centerIn: parent
        ClickableText {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Ofline"
            textSize: 120 * scale
            fontFamily: sfont.name
            onClicked: {
                play()
                console.log("Stage changed to " + root.state)
            }
        }
        ClickableText {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Online"
            textSize: 120 * scale
            fontFamily: sfont.name
            onClicked: {

            }
        }
        ClickableText {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Exit"
            textSize: 120 * scale
            fontFamily: sfont.name
            onClicked: {
                close()
            }
        }
    }
}

