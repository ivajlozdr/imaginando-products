#include "product.h"
#include <QJsonObject>
#include <QJsonValue>
#include <QVariantMap>
#include "controller.h"

Product Product::fromJson(const QJsonObject &obj)
{
    Product out;
    out.id = obj.value("id").toString();
    out.name = obj.value("name").toString();

    QJsonObject meta = obj.value("meta").toObject();
    out.webpage = meta.value("webpage").toString();
    out.logo = meta.value("logo").toString();
    out.cover = meta.value("cover").toString();
    out.colorPrimary = meta.value("color_primary").toString();
    out.colorSecondary = meta.value("color_secondary").toString();
    QString downloadLink = Controller::getDownloadLinkForProduct(out.name);
    qDebug() << "Download link for" << out.name << ":" << downloadLink;
    out.download = downloadLink;

    return out;
}

QVariantMap Product::toVariantMap() const
{
    QVariantMap map;
    map["id"] = id;
    map["name"] = name;
    map["webpage"] = webpage;
    map["logo"] = logo;
    map["cover"] = cover;
    map["colorPrimary"] = colorPrimary;
    map["colorSecondary"] = colorSecondary;
    map["download"] = download;
    return map;
}
