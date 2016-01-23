import QtQuick 2.4
import com.ics.demo 1.0

Item {
    id: root
    anchors.fill: parent

    property alias loader: loader

    state: "menu"    

    focus: true;

    Keys.onReleased: {
        if (event.key == Qt.Key_Back) {
                state = "menu";
                event.accepted = true
            }
    }

    Image {
        id: loaderBackground
        anchors.fill: parent
        source: "qrc:/sources/images/ATTTBG.png"
        fillMode: Image.PreserveAspectFit;
        width: 1080 * window.scale;
        height: 1920 * window.scale;
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
                duration: 1200
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

            property alias next: next
            property alias prev: prev

            anchors.fill: parent
            onItemChanged: item.makeVisible();
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
        source: "qrc:/sources/images/ATTTBG.png"
        fillMode: Image.PreserveAspectFit;
        width: 1080 * window.scale;
        height: 1920 * window.scale;
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
            }
        },
        Transition {
            from: "play"
            to: "menu"
            SequentialAnimation {
                PropertyAnimation {
                    target: loader;
                    properties: "source"
                    to: "Menu.qml"
                }
                ScriptAction {
                    script: prev.start()
                }
                PauseAnimation {
                    duration: 700
                }
            }
        }
    ]
}

