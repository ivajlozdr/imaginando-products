#include "controller.h"
#include <QCoreApplication>
#include <QDebug>
#include <QDir>
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonParseError>
#include <QList>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QVariantMap>
#include "product.h"

Controller::Controller(QObject *parent)
    : QObject(parent)
{
    manager = new QNetworkAccessManager(this);
    connect(manager, &QNetworkAccessManager::finished, this, &Controller::ReplyFinished);
}

void Controller::FetchProducts()
{
    QNetworkRequest request(QUrl("https://api.imaginando.pt/products"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Accept", "application/json");
    manager->get(request);
}

QString Controller::getDownloadLinkForProduct(const QString &product)
{
    QString basePath = QCoreApplication::applicationDirPath();
    QString filePath = basePath + "/../../Downloads.json";

    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to open" << filePath << ":" << file.errorString();
        return {};
    }

    QByteArray jsonData = file.readAll();
    file.close();

    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(jsonData, &error);
    if (error.error != QJsonParseError::NoError) {
        qWarning() << "Error parsing downloads JSON:" << error.errorString();
        return {};
    }

    QJsonObject rootObj = doc.object();
    QJsonObject productObj = rootObj.value(product).toObject();
    QString downloadUrl = productObj.value("win").toString();
    return downloadUrl;
}

void Controller::ReplyFinished(QNetworkReply *reply)
{
    QByteArray responseData = reply->readAll();
    QJsonParseError parseError;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(responseData, &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        qWarning() << "JSON parse error:" << parseError.errorString();
        reply->deleteLater();
        return;
    }

    if (!jsonDoc.isArray()) {
        qWarning() << "Expected JSON array";
        reply->deleteLater();
        return;
    }

    QJsonArray jsonArray = jsonDoc.array();
    QVariantList products;

    for (const QJsonValue &val : jsonArray) {
        QJsonObject obj = val.toObject();
        Product product = Product::fromJson(obj);
        products.append(product.toVariantMap());
    }

    emit dataReady(products);
    reply->deleteLater();
}
