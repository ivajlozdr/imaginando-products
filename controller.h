#pragma once

#include <QNetworkAccessManager>
#include <QObject>
#include <QQmlListProperty>
#include <QVariant>

#include <product.h>

class QNetworkReply;

class Controller : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<Product> model READ model NOTIFY modelChanged)

public:
    explicit Controller(QObject *parent = nullptr);

    QQmlListProperty<Product> model();

    static qsizetype modelCount(QQmlListProperty<Product> *list);
    static Product *modelAt(QQmlListProperty<Product> *list, qsizetype index);

    Q_INVOKABLE void FetchProducts();
    Q_INVOKABLE static QString getDownloadLinkForProduct(const QString &product);

signals:
    void dataReady(QVariantList data);
    void modelChanged();

private slots:
    void ReplyFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager *manager;
    QList<Product *> m_model;
};
