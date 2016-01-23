TEMPLATE = app

QT += qml quick widgets bluetooth

SOURCES += main.cpp \
    bserver/bluetoothclient.cpp \
    bserver/bluetoothserver.cpp \
    cpp/manager.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += bserver/bluetoothclient.h \
    bserver/bluetoothserver.h \
    cpp/manager.h

QMAKE_CXXFLAGS += -std=c++11

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
