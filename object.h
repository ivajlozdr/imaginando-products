#pragma once

#include <QNetworkAccessManager>
#include <QObject>
#include <QVariant>

class QNetworkReply;

class Controller : public QObject
{
    Q_OBJECT
public:
    explicit Controller(QObject *parent = nullptr);

    Q_INVOKABLE void FetchProducts();
    Q_INVOKABLE static QString getDownloadLinkForProduct(const QString &product);
signals:
    void dataReady(QVariantList data);

private slots:
    void ReplyFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager *manager;
};
