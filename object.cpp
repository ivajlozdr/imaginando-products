#include "object.h"
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonParseError>
#include <QVariantMap>
#include <QDebug>

MyObject::MyObject(QObject *parent) : QObject(parent) {
    manager = new QNetworkAccessManager(this);
    connect(manager, &QNetworkAccessManager::finished,
            this, &MyObject::ReplyFinished);
}

void MyObject::TestConnection() {
    QNetworkRequest request(QUrl("https://api.imaginando.pt/products"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Accept", "application/json");
    manager->get(request);
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
        qWarning() << "Expected a JSON array";
        reply->deleteLater();
        return;
    }

    QJsonArray jsonArray = jsonDoc.array();
    QVariantList cleanData;

    for (const QJsonValue &val : jsonArray) {
        QJsonObject obj = val.toObject();
        QVariantMap item;
        item["id"] = obj["id"].toString();
        item["name"] = obj["name"].toString();

        QJsonObject meta = obj["meta"].toObject();
        item["webpage"] = meta["webpage"].toString();
        item["cover"] = meta["cover"].toString();

        cleanData.append(item);
    }

    _model = cleanData;

    emit modelChanged();
    reply->deleteLater();
}
