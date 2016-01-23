import QtQuick 2.4
import QtQuick.Window 2.2
import "./components"

Window {
    id: window

    property double scale: 0.5//Math.min(Screen.height / 1920, Screen.width / 1080);

    visible: true;
    height: 960//1920 * scale;
    width: 540//1080 * scale;

    FontLoader { id: sfont; source: "qrc:/sources/fonts/Schoolbell.ttf";}
    MainForm {

    }
}

