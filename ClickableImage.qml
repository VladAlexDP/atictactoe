import QtQuick 2.0

Item {
    id: root

    property alias source: image.source

    signal clicked

    width: image.width
    height: image.height

    Image {
        id: image        
        MouseArea {
            anchors.fill: parent
            onClicked: root.clicked()
        }
    }
}

