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
    Q_PROPERTY(bool loading READ isLoading WRITE setLoading NOTIFY loadingChanged)
    Q_PROPERTY(qreal downloadProgress READ downloadProgress NOTIFY downloadProgressChanged)
public:
    explicit Controller(QObject *parent = nullptr);

    QQmlListProperty<Product> model();
    bool isLoading() const;
    qreal downloadProgress() const;
    void setLoading(bool loading);
    void setDownloadProgress(qreal progress);

    static qsizetype modelCount(QQmlListProperty<Product> *list);
    static Product *modelAt(QQmlListProperty<Product> *list, qsizetype index);

    Q_INVOKABLE void FetchProducts();
    Q_INVOKABLE static QString getDownloadLinkForProduct(const QString &product);
    Q_INVOKABLE bool unzipFile(const QString &zipPath, const QString &extractPath);
    Q_INVOKABLE void install(const QString &url);
    Q_INVOKABLE void launchInstaller(const QString &folderPath, const QString &exeName);
    Q_INVOKABLE void cleanTempDir();

signals:
    void modelChanged();
    void loadingChanged();
    void downloadProgressChanged(qreal progress);

private slots:
    void ReplyFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager *manager;
    QList<Product *> m_model;
    bool m_loading;
    qreal m_downloadProgress = 0.0;
};
