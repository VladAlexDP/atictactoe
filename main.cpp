#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDesktopWidget>
#include <QQmlProperty>
#include <QQuickView>

#include "cpp/manager.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<Manager>("com.ics.demo", 1, 0, "Manager");

    QQuickView *view = new QQuickView;
    view->setSource(QUrl(QStringLiteral("qrc:/main.qml")));
    view->showFullScreen();
    QObject::connect((QObject*)view->engine(), SIGNAL(quit()), &app, SLOT(quit()));

    return app.exec();
}
