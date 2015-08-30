import QtQuick 2.4
import com.ics.demo 1.0

Item {
    id: root
    anchors.fill: parent

    /*property alias turn: turn
    property alias oscore: oscore
    property alias xscore: xscore
    property alias field: field
    property alias erase: erase
    property alias manager: manager*/
    property alias gameField: gameField
    property alias font: turn.font.family

    Item {
    //Row {
        id: gameField
        anchors.fill: parent

        ClickableImage {
            id: erase
            x: -67.5 * scale * window.scale
            y: window.height/2 - erase.height * window.scale / 2
            scale: window.scale * 0.675
            source: "qrc:/sources/images/eraser.png"
            onClicked: {
                for(var i=0; i < field.squareR.count; ++i) {
                    for(var j=0; j < field.squareR.itemAt(i).cellR.count; ++j)
                        field.squareR.itemAt(i).cellR.itemAt(j).text = "";
                }
                field.canvas.clear();
            }
            Behavior on visible {
                PropertyAnimation { duration: 4000 }
            }
        }

        Item {
            x: erase.width * erase.scale + window.width * 0.05
        //Column {
            //x: erase.width * erase.scale
            //anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: turn
                text: "Turn: X"
                font.pixelSize: 85 * window.scale //
                y: window.height * 0.1 /2
                Behavior on visible {
                    PropertyAnimation { duration: 1000 }
                }
            }
            Row {
                id: score
                y: window.height * 0.12
                spacing: 370 * window.scale - oscore.width //
                Text {
                    id: oscore
                    text: "O: "
                    font.pixelSize: 85 * window.scale //
                    font.family: turn.font.family
                }
                Text {
                    id: xscore
                    text: "X: "
                    font.pixelSize: 85 * window.scale //
                    font.family: turn.font.family
                }
                Behavior on visible {
                    PropertyAnimation { duration: 2000 }
                }
            }
            Field {
                id: field
                font: turn.font.family
                y: score.height*1.3 + score.y
                width: height * 0.75
                height: window.height - y/2
                Behavior on visible {
                    PropertyAnimation { duration: 3000 }
                }
            }
        }

        onVisibleChanged:  {
            field.visible = visible;
            score.visible = visible;
            turn.visible = visible;
            erase.visible = visible;
        }
    }
    Manager {
        id: manager

        square_size_px: field.height / (3 * 1.25) - square_margin

        onCellFilled: {
            if (manager.crosses_turn) {
                field.squareR.itemAt(sIndex).cellR.itemAt(cIndex).text = "X";
                turn.text = "Turn: O";
            } else {
                field.squareR.itemAt(sIndex).cellR.itemAt(cIndex).text = "O";
                turn.text = "Turn: X";
            }
        }
        onScoreChanged: {
            if(manager.crosses_turn)
                xscore.text += "I"
            else
                oscore.text += "I"

            field.canvas.drawLine(bHCoords, bVCoords, eHCoords, eVCoords)
        }
        onErase: {
            xscore.text = "X: "
            oscore.text = "O: "
            turn.text = "Turn: X"
        }
    }
}

