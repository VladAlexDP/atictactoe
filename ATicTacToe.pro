TEMPLATE = app

QT += qml quick widgets bluetooth

SOURCES += main.cpp \
    manager.cpp \
    bluetoothserver.cpp \
    bluetoothclient.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    manager.h \
    bluetoothserver.h \
    bluetoothclient.h

QMAKE_CXXFLAGS += -std=c++11
