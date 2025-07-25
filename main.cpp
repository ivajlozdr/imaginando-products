#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "controller.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<Product>("untitled", 1, 0, "Product");
    qmlRegisterType<Modules>("untitled", 1, 0, "Modules");

    Controller controller;
    engine.rootContext()->setContextProperty("controller", &controller);

    controller.FetchProducts();

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    qmlRegisterSingletonType(QUrl("qrc:/Styles.qml"), "untitled", 1, 0, "Styles");
    engine.loadFromModule("untitled", "Main");

    return app.exec();
}
