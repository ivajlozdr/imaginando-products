#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "object.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    MyObject myObject;
    engine.rootContext()->setContextProperty("backend", &myObject);

    myObject.TestConnection();

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    qmlRegisterSingletonType(QUrl("qrc:/Styles.qml"), "App", 1, 0, "Styles");

    engine.loadFromModule("untitled", "Main");

    return app.exec();
}
