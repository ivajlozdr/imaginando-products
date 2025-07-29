#include "modules.h"
#include <QDebug>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>

Modules::Modules(QObject *parent)
    : QObject(parent)
{}

QString Modules::id() const
{
    return m_id;
}
QString Modules::name() const
{
    return m_name;
}
QString Modules::purchase() const
{
    return m_purchase;
}
QString Modules::logo() const
{
    return m_logo;
}
QString Modules::description() const
{
    return m_description;
}

int Modules::priceCurrent() const
{
    return m_priceCurrent;
}

Modules *Modules::fromJson(const QJsonObject &obj, QObject *parent)
{
    Modules *out = new Modules(parent);

    out->m_id = obj.value("id").toString();
    out->m_name = obj.value("name").toString();

    QJsonObject meta = obj.value("meta").toObject();
    out->m_logo = meta.value("cover").toString();
    out->m_purchase = meta.value("purchase").toString();
    out->m_description = meta.value("description").toString();

    const QJsonArray os = obj.value("operatingSystems").toArray();
    if (!os.isEmpty() && os.first().isObject()) {
        QJsonObject firstOs = os.first().toObject();
        out->m_priceCurrent = firstOs.value("one_time_price").toDouble();
    }

    return out;
}
