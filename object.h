#pragma once

#include <QNetworkAccessManager>
#include <QObject>
#include <QVariant>

class QNetworkReply;

class MyObject : public QObject {
    Q_OBJECT
public:
    explicit MyObject(QObject *parent = nullptr);

    Q_INVOKABLE void TestConnection();
    Q_INVOKABLE static QString getDownloadLinkForProduct(const QString &product);
signals:
    void dataReady(QVariantList data);

private slots:
    void ReplyFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager *manager;
};
