#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include "controller.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Basic");
    QQmlApplicationEngine engine;

    qmlRegisterType<Product>("imaginando", 1, 0, "Product");
    qmlRegisterType<Modules>("imaginando", 1, 0, "Modules");

    Controller controller;
    engine.rootContext()->setContextProperty("controller", &controller);

    controller.FetchProducts();

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    qmlRegisterSingletonType(QUrl("qrc:/Styles.qml"), "imaginando", 1, 0, "Styles");
    engine.loadFromModule("imaginando", "Main");

    return app.exec();
}
