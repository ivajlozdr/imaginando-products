#include "object.h"
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonParseError>
#include <QDebug>
#include <QUrl>

MyObject::MyObject(QObject *parent) : QObject(parent) {
    manager = new QNetworkAccessManager(this);
    connect(manager, &QNetworkAccessManager::finished,
            this, &MyObject::ReplyFinished);
}

void MyObject::TestConnection() {
    manager->get(QNetworkRequest(QUrl("https://api.imaginando.pt/products")));
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
    emit dataReady(jsonArray);

    reply->deleteLater();
}
