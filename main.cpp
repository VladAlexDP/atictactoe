#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDesktopWidget>
#include <QQmlProperty>

#include "cpp/manager.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<Manager>("com.ics.demo", 1, 0, "Manager");

    QQmlApplicationEngine engine;
    QQmlComponent component(&engine,
            QUrl(QStringLiteral("qrc:/main.qml")));
    QObject *object = component.create();

    /*QRect rec = QApplication::desktop()->screenGeometry();
#if (defined(__linux__) || defined(__MINGW32__))
    QQmlProperty(object, "width").write(rec.width() / 3);
#elif defined(__ANDROID__)
    QQmlProperty(object, "width").write(rec.width());
#endif*/

    return app.exec();
}
