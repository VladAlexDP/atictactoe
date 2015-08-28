import QtQuick 2.4

Item {
    id: root

    property alias text: label.text
    property alias textSize: label.font.pixelSize
    property alias fontFamily: label.font.family

    signal clicked

    width: label.width
    height: label.height

    Text {
        id: label

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        MouseArea {
           anchors.fill: parent
           onClicked: root.clicked()
       }
    }

}

