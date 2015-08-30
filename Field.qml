import QtQuick 2.4

Grid {
    id: root

    rows: 3; columns: 2

    property int canvasMargin: 10
    property int fontSize: 100
    property int borderWidth: 3
    property int squareSize: 200
    property int lineWidth: 4
    property string fontFamily: "Arial"
    property alias model: squareR.model
    property alias squareRepeater: squareR

    signal clicked(var sIndex, var cIndex);

    function clear() {
        for(var i=0; i < squareR.count; ++i) {
            for(var j=0; j < squareR.itemAt(i).cellRepeater.count; ++j)
                squareR.itemAt(i).cellRepeater.itemAt(j).text = "";
        }
    }
    function drawLine(sIndex, bHCoords, bVCoords, eHCoords, eVCoords) {
        squareR.itemAt(sIndex).drawLine(bHCoords, bVCoords, eHCoords, eVCoords);
    }

    Repeater {
        id: squareR
        Square {
            cMargin: root.canvasMargin
            fSize: root.fontSize
            fFamily: fontFamily
            bWidth: root.borderWidth
            width: root.squareSize; height: root.squareSize

            onClicked: {
                root.clicked(index, cIndex);
            }
        }
    }
}
