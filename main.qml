import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import "./components"

Item {
    id: window

    property double scale: Math.min((Screen.height)/1920, Screen.width / 1080);

    visible: true;
    height: 1920 * scale;
    width: 1080 * scale;

    FontLoader { id: sfont; source: "qrc:/sources/fonts/Schoolbell.ttf";}
    SmartBG {
        id: pages;
    }
}

