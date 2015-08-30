#include <QApplication>
#include <QQmlApplicationEngine>

#include "manager.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<Manager>("com.ics.demo", 1, 0, "Manager");

    QQmlApplicationEngine engine;
    QQmlComponent component(&engine,
            QUrl(QStringLiteral("qrc:/main.qml")));
    component.create();

    return app.exec();
}
