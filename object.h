#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QVariant>

class QNetworkReply;

class MyObject : public QObject {
    Q_OBJECT
public:
    explicit MyObject(QObject *parent = nullptr);

    Q_INVOKABLE void TestConnection();

signals:
    void dataReady(QVariant data);

private slots:
    void ReplyFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager *manager;
};
