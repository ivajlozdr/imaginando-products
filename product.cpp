#include "product.h"
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>
#include <QVariantList>
#include <QVariantMap>
#include "controller.h"
#include "modules.h"

Product::Product(QObject *parent)
    : QObject(parent)
{}

QString Product::id() const
{
    return m_id;
}
QString Product::name() const
{
    return m_name;
}
QString Product::webpage() const
{
    return m_webpage;
}
QString Product::download() const
{
    return m_download;
}
QString Product::logo() const
{
    return m_logo;
}
QString Product::cover() const
{
    return m_cover;
}
QString Product::colorPrimary() const
{
    return m_colorPrimary;
}
QString Product::colorSecondary() const
{
    return m_colorSecondary;
}

QQmlListProperty<Modules> Product::modules()
{
    return QQmlListProperty<Modules>(this, &m_modules);
}

Product *Product::fromJson(const QJsonObject &obj)
{
    Product *out = new Product(nullptr);

    out->m_id = obj.value("id").toString();
    out->m_name = obj.value("name").toString();

    const QJsonObject meta = obj.value("meta").toObject();
    out->m_webpage = meta.value("webpage").toString();
    out->m_logo = meta.value("logo").toString();
    out->m_cover = meta.value("cover").toString();
    out->m_colorPrimary = meta.value("color_primary").toString();
    out->m_colorSecondary = meta.value("color_secondary").toString();
    out->m_download = Controller::getDownloadLinkForProduct(out->m_name);

    const QJsonArray modulesArray = meta.value("modules").toArray();
    for (const QJsonValue &val : modulesArray) {
        if (val.isObject()) {
            Modules *mod = Modules::fromJson(val.toObject());
            if (mod)
                out->m_modules.append(mod);
        }
    }

    return out;
}

QVariantMap Product::toVariantMap() const
{
    QVariantMap map;

    map["id"] = m_id;
    map["name"] = m_name;
    map["webpage"] = m_webpage;
    map["logo"] = m_logo;
    map["cover"] = m_cover;
    map["colorPrimary"] = m_colorPrimary;
    map["colorSecondary"] = m_colorSecondary;
    map["download"] = m_download;

    QVariantList modulesList;
    for (Modules *mod : m_modules) {
        if (mod)
            modulesList.append(mod->toVariantMap());
    }

    map["modules"] = modulesList;

    return map;
}
