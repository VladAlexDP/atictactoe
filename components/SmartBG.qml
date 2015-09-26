import QtQuick 2.0

Item {
    id: root
    anchors.fill: parent

    property alias loader: loader

    state: "menu"

    Image {
        id: loaderBackground
        anchors.fill: parent
        source: "qrc:/sources/images/bg_new.png"
        transform: Rotation {
            id: rotation
            angle: 0
            origin.x: 0
            origin.y: parent.height/2
            axis.x: 0; axis.y: -1; axis.z: 0
        }

        SequentialAnimation {
            id: next
            NumberAnimation {
                duration: 1000
                target: rotation
                property: "angle"
                from: 0
                to: 90
            }
            NumberAnimation {
                duration: 0
                target: rotation
                property: "angle"
                from: 90
                to: 0
            }
        }
        SequentialAnimation {
            id: prev
            NumberAnimation {
                duration: 1000
                target: rotation
                property: "angle"
                from: 90
                to: 0
            }
        }

        Loader {
            id: loader
            anchors.fill: parent
        }
        Connections {
            target: loader.item
            onPlay: state = "play"
        }
    }

    Image {
        id: background
        z: -2
        anchors.fill: parent
        source: "qrc:/sources/images/bg_new.png"
    }


    states: [
        State {
            name: "menu"
            PropertyChanges {
                target: loader;
                source: "Menu.qml"
            }
        },
        State {
            name: "play"
            PropertyChanges {
                target: loader;
                source: "Game.qml"
            }
        }
    ]
    transitions: [
        Transition {
            from: "menu"
            to: "play"
            SequentialAnimation {
                ScriptAction {
                    script: next.start()
                }
                PauseAnimation {
                    duration: 700
                }
                PropertyAnimation {
                    target: loader;
                    properties: "source"
                    to: "Game.qml"
                }
                PropertyAnimation {
                    target: loader.item;
                    properties: "visible"
                    from: false
                    to: true
                }
            }
        }
    ]
}

