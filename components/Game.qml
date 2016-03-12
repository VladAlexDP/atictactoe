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

    function makeInvisible() {
        field.visible = false;
        score.visible = false;
        turn.visible =  false;
    }

    MouseArea {

        id: swipeArea
        anchors.fill: parent
        preventStealing: true
        property real xVelocity: 0.0
        property real yVelocity: 0.0
        property int xStart: 0
        property int xPrev: 0
        property int yStart: 0
        property int yPrev: 0
        property bool tracing: false

        onPressed: {
            xStart = mouse.x
            xPrev = mouse.x
            yStart = mouse.y
            yPrev = mouse.y

            xVelocity = 0
            yVelocity = 0
            tracing = true
        }
        onPositionChanged: {
            if (!tracing)
                return

            var xCurrVel = (mouse.x - xPrev)
            xVelocity = (xVelocity + xCurrVel) / 2.0
            xPrev = mouse.x

            var yCurrVel = (mouse.y - yPrev)
            yVelocity = (yVelocity + yCurrVel) / 2.0
            yPrev = mouse.y
        }
        onReleased: {
            tracing = false
            var angle = 0;
            var radToDegK = 180 / Math.PI;

            if ((Math.abs(xVelocity) > 1 && Math.abs(xPrev - xStart) > parent.width / 3)
                || (Math.abs(yVelocity) > 1 && Math.abs(yPrev - yStart) > parent.height / 4)) {

                angle = Math.atan2(xPrev - xStart, yPrev - yStart) * radToDegK;
                manager.recGesture(angle);
            }

        }

        Item {
            id: gameField

            anchors { fill: parent; leftMargin: 60 * window.scale }

            Text {
                id: turn
                //anchors.top: parent.top
                //anchors.topMargin: 0 * window.scale
                text: "Turn: X"
                font.pixelSize: 80 * window.scale
                font.family: sfont.name
                visible: false;
                Behavior on visible  {
                    PropertyAnimation { duration: 750  }
                }
            }
            Row {
                id: score
                anchors.top: parent.top
                anchors.topMargin: 100 * window.scale
                spacing: (980 / 2) * window.scale - oscore.width
                visible: false;
                Text {
                    id: oscore
                    text: "O: "
                    font.pixelSize: 80 * window.scale
                    font.family: turn.font.family
                }
                Text {
                    id: xscore
                    text: "X: "
                    font.pixelSize: 80 * window.scale
                    font.family: turn.font.family
                }
                Behavior on visible  {
                    PropertyAnimation { duration: 1500  }
                }
            }
            Field {
                id: field
                anchors { top: parent.top; topMargin: 280 * window.scale }
                model: 6
                fontFamily: turn.font.family
                fontSize: 145 * window.scale
                lineWidth: 8 * window.scale
                borderWidth: 4 * window.scale
                squareSize: 420 * window.scale
                spacing: 140 * window.scale
                visible: false;
                onClicked: {
                    manager.registTurn(sIndex, cIndex)
                }
                Behavior on visible  {
                    PropertyAnimation { duration: 2250  }
                }
            }
        }
    }

    Manager {
        id: manager

        square_size_px: field.squareSize

        onCellFilled: {
            if (manager.crosses_turn) {
                turn.text = "Turn: O";
            } else {
                turn.text = "Turn: X";
            }
            field.fillCell(sIndex, cIndex, manager.crosses_turn)
        }
        onScoreChanged: {
            if(crosses) {
                xscore.text = "X: ";
                for(var i = 0; i < value; i++)
                    xscore.text += "I";
             } else {
                oscore.text = "O: ";
                for(var i = 0; i < value; i++)
                    oscore.text += "I";
            }
        }
        onLineAdded: {
            field.drawLine(sIndex, bHCoords, bVCoords, eHCoords, eVCoords);
        }
        onErase: {
            xscore.text = "X: "
            oscore.text = "O: "
            turn.text = "Turn: X"
            field.clear();
        }
        onFillCell: {
            field.fillCell(squareNum, cellNum, cross);
        }
        onNextPage: {
            parent.next.start();
            makeInvisible();
            turn.text = crosses_turn ? "Turn: X" : "Turn: O"
            makeVisible();
        }
        onPrevPage: {
            parent.prev.start();
            makeInvisible();
            turn.text = crosses_turn ? "Turn: X" : "Turn: O"
            makeVisible();
        }
    }

}

