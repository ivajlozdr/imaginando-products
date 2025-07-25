#ifndef MODULES_H
#define MODULES_H

#include <QObject>
#include <QVariantMap>

class Modules : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY idChanged FINAL)
    Q_PROPERTY(QString name READ name NOTIFY nameChanged FINAL)
    Q_PROPERTY(QString purchase READ purchase NOTIFY purchaseChanged FINAL)
    Q_PROPERTY(QString logo READ logo NOTIFY logoChanged FINAL)
    Q_PROPERTY(QString description READ description NOTIFY descriptionChanged FINAL)

public:
    explicit Modules(QObject *parent = nullptr);

    QString id() const;
    QString name() const;
    QString purchase() const;
    QString logo() const;
    QString description() const;

    static Modules *fromJson(const QJsonObject &obj, QObject *parent = nullptr);

signals:
    void idChanged();
    void nameChanged();
    void purchaseChanged();
    void logoChanged();
    void descriptionChanged();

private:
    QString m_id;
    QString m_name;
    QString m_purchase;
    QString m_logo;
    QString m_description;
};

Q_DECLARE_METATYPE(Modules *)

#endif // MODULES_H
