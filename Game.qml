import QtQuick 2.4
import com.ics.demo 1.0

Item {
    id: root
    anchors.fill: parent

    property alias gameField: gameField
    property alias font: turn.font.family

    Item {
        id: gameField
        anchors.fill: parent

        ClickableImage {
            id: erase
            x: -208 * scale * window.scale
            y: window.height/2 - erase.height * window.scale / 2
            scale: window.scale * 0.6
            source: "qrc:/sources/images/eraser.png"
            onClicked: {
                field.clear();
                manager.clearField();
            }
            Behavior on visible {
                PropertyAnimation { duration: 4000 }
            }
        }

        Item {
            x: erase.width * erase.scale + window.width * 0.05
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
                spacing: 325 * window.scale - oscore.width //
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
                y: score.height + score.y
                height: window.height - y/2
                model: 6
                fontFamily: turn.font.family
                onClicked: {
                    manager.registTurn(sIndex, cIndex)
                }
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
                field.squareRepeater.itemAt(sIndex).cellRepeater.itemAt(cIndex).text = "X";
                turn.text = "Turn: O";
            } else {
                field.squareRepeater.itemAt(sIndex).cellRepeater.itemAt(cIndex).text = "O";
                turn.text = "Turn: X";
            }
        }
        onScoreChanged: {
            if(manager.crosses_turn)
                xscore.text += "I"
            else
                oscore.text += "I"

            field.drawLine(sIndex, bHCoords, bVCoords, eHCoords, eVCoords);
        }
        onErase: {
            xscore.text = "X: "
            oscore.text = "O: "
            turn.text = "Turn: X"
        }
    }
}

