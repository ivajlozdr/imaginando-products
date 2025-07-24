#include "object.h"
#include <QDebug>
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

MyObject::MyObject(QObject *parent) : QObject(parent) {
    manager = new QNetworkAccessManager(this);
    connect(manager, &QNetworkAccessManager::finished,
            this, &MyObject::ReplyFinished);
}

void MyObject::FetchProducts()
{
    QNetworkRequest request(QUrl("https://api.imaginando.pt/products"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Accept", "application/json");
    manager->get(request);
}

QString MyObject::getDownloadLinkForProduct(const QString& product) {
    const QString filePath = "./Downloads.json";

    QFile file(filePath);
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

void MyObject::ReplyFinished(QNetworkReply *reply) {
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
