import QtQuick 2.4

Canvas {
    id: root

    property int fSize: 100
    property int bWidth: 3
    property int lWidth: 10
    property string fFamily: "Arial"
    property alias cellRepeater: cellR

    signal clicked(var cIndex);

    function drawLine(bHCoords, bVCoords, eHCoords, eVCoords) {
        var context = getContext("2d");
        context.lineWidth = lWidth;
        context.strokeStyle = "black";
        context.beginPath();
        context.moveTo(bHCoords, bVCoords);
        context.lineTo(eHCoords, eVCoords);
        context.closePath();
        context.stroke();
    }
    function clear() {
        var context = getContext("2d");
        context.clearRect(0, 0, width, height);
    }

    Grid {
        id: cellGrid

        width: parent.width
        height: parent.height
        columns: 3; rows: 3;        

        Repeater {
            id: cellR

            model: 9

            Rectangle {
                property alias text: text.text
                property int cIndex: index

                width: cellGrid.width / 3; height: width
                border { width: bWidth; color: "black" }
                color: "transparent"

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.clicked(index)
                }
                Text {
                    id: text
                    anchors.centerIn: parent
                    font { pixelSize: fSize; family: fFamily }
                }
            }
        }
    }
}

