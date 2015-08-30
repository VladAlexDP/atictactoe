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
        //x: -110
        id: gameField

        ClickableImage {
            id: erase
            width: 200
            height: 500
            x: -110
            y: 310
            scale: 0.4
            rotation: 90
            source: "qrc:/sources/images/eraser.png"
            onClicked: {
                for(var i=0; i < field.squareR.count; ++i) {
                    for(var j=0; j < field.squareR.itemAt(i).cellR.count; ++j)
                        field.squareR.itemAt(i).cellR.itemAt(j).isource = "";
                }
                field.canvas.clear();
            }
            Behavior on visible {
                PropertyAnimation { duration: 4000 }
            }
        }

        Item {
            x: 100
            y: 15
            Column {
                spacing: 19 //
                Text {
                    id: turn
                    text: "Turn: X"
                    font.pixelSize: 50 //
                    Behavior on visible {
                        PropertyAnimation { duration: 1000 }
                    }
                }
                Row {
                    id: score
                    spacing: 250 - oscore.width //
                    Text {
                        id: oscore
                        text: "O: "
                        font.pixelSize: 50 //
                        font.family: turn.font.family
                    }
                    Text {
                        id: xscore
                        text: "X: "
                        font.pixelSize: 50 //
                        font.family: turn.font.family
                    }
                    Behavior on visible {
                        PropertyAnimation { duration: 2000 }
                    }
                }
                Field {
                    id: field
                    font: turn.font.family
                    Behavior on visible {
                        PropertyAnimation { duration: 3000 }
                    }
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
        onCellFilled: {
            if (manager.crosses_turn) {
                field.squareR.itemAt(sIndex).cellR.itemAt(cIndex).isource = "X";
                turn.text = "Turn: O";
            } else {
                field.squareR.itemAt(sIndex).cellR.itemAt(cIndex).isource = "O";
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

