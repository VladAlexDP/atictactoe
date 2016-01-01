import QtQuick 2.4

MouseArea {

    id: globalMouseArea
    anchors.fill: parent
    preventStealing: true
    property real velocity: 0.0
    property int xStart: 0
    property int xPrev: 0
    property bool tracing: false

    onPressed: {
        xStart = mouse.x
        xPrev = mouse.x
        velocity = 0
        tracing = true
    }
    onPositionChanged: {
        if (!tracing)
            return

        var currVel = (mouse.x - xPrev)
        velocity = (velocity + currVel)/2.0
        xPrev = mouse.x

    }
    onReleased: {
        tracing = false
        if (velocity > 15 && mouse.x > parent.width) {
            console.log("SWIPE DETECTED !! EMIT SIGNAL or DO your action");
        }
    }
}
