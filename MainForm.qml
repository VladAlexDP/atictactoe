import QtQuick 2.4
import com.ics.demo 1.0

Image {
    id: backgroundGame
    source: "qrc:/sources/images/bg.jpg"
    width: window.width
    height: window.height
    property alias font: game.font

    Game {
        id: game
    }
}

