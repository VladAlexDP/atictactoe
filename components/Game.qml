import QtQuick 2.4
import com.ics.demo 1.0

Item {
    id: root
    anchors.fill: parent

    property alias gameField: gameField
    property alias font: turn.font.family

    function makeVisible() {
        field.visible = true;
        score.visible = true;
        turn.visible =  true;
    }

    Item {
        id: gameField

        anchors { fill: parent; leftMargin: 35 * window.scale }

        Text {
            id: turn
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 10 * window.scale
            text: "Turn: O"
            font.pixelSize: 35 * window.scale
            font.family: sfont.name
            visible: false;
            Behavior on visible  {
                PropertyAnimation { duration: 750  }
            }
        }
        Row {
            id: score
            anchors.top: turn.bottom
            anchors.topMargin: -16 * window.scale
            spacing: 250 * window.scale - oscore.width
            visible: false;
            Text {
                id: oscore
                text: "O: "
                font.pixelSize: 30 * window.scale
                font.family: turn.font.family
            }
            Text {
                id: xscore
                text: "X: "
                font.pixelSize: 30 * window.scale
                font.family: turn.font.family
            }
            Behavior on visible  {
                PropertyAnimation { duration: 1500  }
            }
        }
        Field {
            id: field
            anchors { left: parent.left; top: score.bottom; topMargin: 15 * window.scale }
            model: 6
            fontFamily: turn.font.family
            fontSize: 65 * window.scale
            lineWidth: 4 * window.scale
            borderWidth: 2 * window.scale
            squareSize: 157 * window.scale
            spacing: 26 * window.scale
            visible: false;
            onClicked: {
                manager.registTurn(sIndex, cIndex)
            }
            Behavior on visible  {
                PropertyAnimation { duration: 2250  }
            }
        }        
    }
    Manager {
        id: manager

        square_size_px: field.squareSize

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

