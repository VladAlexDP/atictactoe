import QtQuick 2.0

Item {
    id: root

    property alias mirror: bg.mirror
    property alias height: height
    property alias width: width
    signal clicked

    Image {
        id: bg
        source: "qrc:/images/bg.jpg"
        anchors.fill: parent

        MouseArea {
            anchors.fill: parent
            onClicked: root.clicked
        }
    }
}

