import QtQuick 2.5
import QtQuick.Window 2.2
import "./components"

Window {
    id: window

    property double scale: height / 674

    visible: true;
    height: 674;
    width: 409;

    FontLoader { id: sfont; source: "qrc:/sources/fonts/Schoolbell.ttf";}
    MainForm {

    }
}

