#ifndef PRODUCT_H
#define PRODUCT_H

#include <QObject>
#include <QQmlListProperty>
#include "modules.h"

class Product : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY idChanged FINAL)
    Q_PROPERTY(QString name READ name NOTIFY nameChanged FINAL)
    Q_PROPERTY(QString webpage READ webpage NOTIFY webpageChanged FINAL)
    Q_PROPERTY(QString download READ download NOTIFY downloadChanged FINAL)
    Q_PROPERTY(QString logo READ logo NOTIFY logoChanged FINAL)
    Q_PROPERTY(QString cover READ cover NOTIFY coverChanged FINAL)
    Q_PROPERTY(QString colorPrimary READ colorPrimary NOTIFY colorPrimaryChanged FINAL)
    Q_PROPERTY(QString colorSecondary READ colorSecondary NOTIFY colorSecondaryChanged FINAL)
    Q_PROPERTY(QQmlListProperty<Modules> modules READ modules NOTIFY modulesChanged FINAL)

public:
    Product(QObject *parent);

    QString id() const;
    QString name() const;
    QString webpage() const;
    QString download() const;
    QString logo() const;
    QString cover() const;
    QString colorPrimary() const;
    QString colorSecondary() const;
    QQmlListProperty<Modules> modules();

    static Product *fromJson(const QJsonObject &obj);

    QVariantMap toVariantMap() const;

signals:
    void idChanged();
    void nameChanged();
    void webpageChanged();
    void downloadChanged();
    void logoChanged();
    void coverChanged();
    void colorPrimaryChanged();
    void colorSecondaryChanged();
    void modulesChanged();

private:
    QString m_id;
    QString m_name;
    QString m_webpage;
    QString m_download;
    QString m_logo;
    QString m_cover;
    QString m_colorPrimary;
    QString m_colorSecondary;
    QList<Modules *> m_modules;
};

Q_DECLARE_METATYPE(Product *)

#endif // PRODUCT_H
