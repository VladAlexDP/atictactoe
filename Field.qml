import QtQuick 2.4

Item {
    id: root

    property alias squareR: squareR
    property alias canvas: canvas
    property string font

    Canvas {
        id: canvas        

        function drawLine(bHCoords, bVCoords, eHCoords, eVCoords) {
            var context = getContext("2d");
            context.strokeStyle = "black";
            context.beginPath();
            context.lineWidth = 5 * window.scale; //
            context.moveTo(bHCoords, bVCoords);
            context.lineTo(eHCoords, eVCoords);
            context.stroke();
            requestPaint();
        }
        function clear() {
            var context = getContext("2d");
            context.clearRect(0, 0, width, height);
            requestPaint();
            manager.clearField();
        }

        anchors.fill: parent
        width: root.width
        height: root.height
    }

    Grid {
        columns: 2
        rows: 3
        spacing: manager.square_margin

        Repeater {
            id: squareR
            model: 6
            Grid {
                property int sqIndex: index
                property alias cellR: cellR

                columns:3
                rows: 3
                spacing: -3

                Repeater {
                    model: 9
                    id: cellR
                    Rectangle {
                        property alias text: image.text

                        width: root.width/9
                        height: width
                        border.width: 3 * window.scale
                        border.color: "black"
                        color: "transparent"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: manager.registTurn(index, sqIndex)
                        }
                        Text {
                            id: image
                            anchors.centerIn: parent
                            font.pixelSize: 200 * erase.scale//
                            font.family: root.font
                        }
                    }
                }
            }
        }
    }
}
