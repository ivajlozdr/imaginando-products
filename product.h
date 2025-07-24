#define PRODUCT_H

#include <QObject>

class Product
{
public:
    QString id;
    QString name;
    QString webpage;
    QString download;
    QString logo;
    QString cover;
    QString colorPrimary;
    QString colorSecondary;

    static Product fromJson(const QJsonObject &obj);
    QVariantMap toVariantMap() const;
};

Q_DECLARE_METATYPE(Product)
