#include "modules.h"
#include <QDebug>
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

Modules *Modules::fromJson(const QJsonObject &obj, QObject *parent)
{
    Modules *out = new Modules(parent);
    qDebug() << "called";
    qDebug() << obj;

    out->m_id = obj.value("id").toString();
    out->m_name = obj.value("name").toString();

    QJsonObject meta = obj.value("meta").toObject();
    out->m_logo = meta.value("logo").toString();
    out->m_purchase = meta.value("purchase").toString();
    out->m_description = meta.value("description").toString();

    qDebug() << "Parsed Module:" << out->m_id << out->m_name << out->m_logo << out->m_purchase
             << out->m_description;

    return out;
}
