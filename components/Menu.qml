import QtQuick 2.4

Item {
    signal play

    anchors.fill: parent    

    Column {
        id: menu
        anchors.centerIn: parent
        spacing: 70 * scale;
        ClickableText {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Ofline"
            textSize: 140 * scale
            fontFamily: sfont.name
            onClicked: {
                play()
                console.log("Stage changed to " + root.state)
            }
        }
        ClickableText {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Online"
            textSize: 140 * scale
            fontFamily: sfont.name
            onClicked: {

            }
        }
        ClickableText {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Exit"
            textSize: 140 * scale
            fontFamily: sfont.name
            onClicked: {
                close()
            }
        }
    }
}

