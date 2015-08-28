import QtQuick 2.4

Item {
    id: root

    property alias squareR: squareR
    property alias canvas: canvas

    width: 600
    height: 600

    Canvas {
        id: canvas        

        function drawLine(bHCoords, bVCoords, eHCoords, eVCoords) {
            var context = getContext("2d");
            context.strokeStyle = "black";
            context.beginPath();
            context.lineWidth = 5;
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
        x: 0; y: 0; z: 5
        width: root.width
        height: root.height
    }

    Grid {
        columns: 2
        rows: 3
        spacing: manager.square_margin / 10 - 1
        //x: 0; y: 0

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
                        property alias isource: image.source

                        width: root.width/9
                        height: width
                        border.width: 3
                        border.color: "black"
                        color: "transparent"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: manager.registTurn(index, sqIndex)
                        }
                        Image {
                            id: image
                            anchors.fill: parent
                        }
                    }
                }
            }
        }
    }
}
