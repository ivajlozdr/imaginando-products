#include "object.h"
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonParseError>
#include <QVariantMap>
#include <QDebug>
#include <QFile>

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

QString MyObject::getDownloadLinkForProduct(const QString& product) {
    const QString filePath = "../Downloads.json";

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

    QJsonArray jsonArray = jsonDoc.array();
    QVariantList cleanData;

    for (const QJsonValue &val : jsonArray) {
        QJsonObject obj = val.toObject();
        QVariantMap item;
        item["id"] = obj["id"].toString();
        item["name"] = obj["name"].toString();

        QJsonObject meta = obj["meta"].toObject();
        item["webpage"] = meta["webpage"].toString();
        item["logo"] = meta["logo"].toString();
        item["cover"] = meta["cover"].toString();
        item["colorPrimary"] = meta["color_primary"].toString();
        item["colorSecondary"] = meta["color_secondary"].toString();
        for (const QVariant &variant : cleanData) {
            QVariantMap product = variant.toMap();
            QString productName = product["id"].toString();

            QString downloadLink = getDownloadLinkForProduct(productName);
            qDebug() << "Download link for" << productName << ":" << downloadLink;
            item["download"] = downloadLink;
        }
        cleanData.append(item);
    }

    emit dataReady(cleanData);
    reply->deleteLater();
}
