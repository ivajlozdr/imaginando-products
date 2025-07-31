#include "controller.h"
#include <QCoreApplication>
#include <QDebug>
#include <QDir>
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonParseError>
#include <QList>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QProcess>
#include <QStandardPaths>
#include <QThread>
#include <QVariantMap>
#include "product.h"

bool m_loading = false;

Controller::Controller(QObject *parent)
    : QObject(parent)
{
    manager = new QNetworkAccessManager(this);
}

QQmlListProperty<Product> Controller::model()
{
    return QQmlListProperty<Product>(this, this, &Controller::modelCount, &Controller::modelAt);
}

bool Controller::isLoading() const
{
    return m_loading;
}

qreal Controller::downloadProgress() const
{
    return m_downloadProgress;
}

void Controller::setLoading(bool loading)
{
    if (m_loading == loading)
        return;

    m_loading = loading;
    emit loadingChanged();
}

void Controller::setDownloadProgress(qreal progress)
{
    if (m_downloadProgress != progress) {
        m_downloadProgress = progress;
        emit downloadProgressChanged(progress);
    }
}

qsizetype Controller::modelCount(QQmlListProperty<Product> *list)
{
    auto *controller = qobject_cast<Controller *>(list->object);
    return controller ? controller->m_model.size() : 0;
}

Product *Controller::modelAt(QQmlListProperty<Product> *list, qsizetype index)
{
    auto *controller = qobject_cast<Controller *>(list->object);
    return controller && index < controller->m_model.count() ? controller->m_model.at(index)
                                                             : nullptr;
}

void Controller::FetchProducts()
{
    QNetworkRequest request(QUrl("https://api.imaginando.pt/products"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Accept", "application/json");

    QNetworkReply *reply = manager->get(request);

    connect(reply, &QNetworkReply::finished, this, [=]() { ReplyFinished(reply); });
}

bool Controller::unzipFile(const QString &zipPath, const QString &extractPath)
{
    QFileInfo zipInfo(zipPath);
    if (!zipInfo.exists()) {
        qWarning() << "ZIP file does not exist at path:" << zipPath;
        return false;
    }

    qDebug() << "ZIP file exists. Size:" << zipInfo.size() << "bytes";
    qDebug() << "Unzipping: " << zipPath << " to " << extractPath;

    QString command = QString("powershell.exe");
    QStringList args
        = {"Expand-Archive", "-Path", zipPath, "-DestinationPath", extractPath, "-Force"};

    QProcess process;
    process.setProgram(command);
    process.setArguments(args);
    process.setProcessChannelMode(QProcess::MergedChannels);

    qDebug() << "Running command:" << command << args.join(" ");

    if (!process.startDetached()) {
        qWarning() << "Failed to launch PowerShell. Error:" << process.errorString();
        return false;
    }

    process.start(command, args);
    if (!process.waitForStarted()) {
        qWarning() << "PowerShell failed to start:" << process.errorString();
        return false;
    }

    if (!process.waitForFinished()) {
        qWarning() << "PowerShell unzip process did not finish.";
        return false;
    }

    QString stdoutOutput = QString::fromUtf8(process.readAllStandardOutput());
    QString stderrOutput = QString::fromUtf8(process.readAllStandardError());

    qDebug() << "PowerShell stdout:\n" << stdoutOutput;
    qDebug() << "PowerShell stderr:\n" << stderrOutput;
    qDebug() << "PowerShell exit code:" << process.exitCode();

    if (process.exitCode() != 0) {
        qWarning() << "Unzip failed with exit code" << process.exitCode();
        return false;
    }

    return true;
}

QString Controller::getDownloadLinkForProduct(const QString &product)
{
    QString basePath = QCoreApplication::applicationDirPath();
    QString filePath = basePath + "/../../Downloads.json";

    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to open" << filePath << ":" << file.errorString();
        return {};
    }

    QByteArray jsonData = file.readAll();
    file.close();

    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(jsonData, &error);
    if (error.error != QJsonParseError::NoError) {
        qWarning() << "Error parsing downloads JSON:" << error.errorString();
        return {};
    }

    QJsonObject rootObj = doc.object();
    QJsonObject productObj = rootObj.value(product).toObject();
    QString downloadUrl = productObj.value("win").toString();

    if (downloadUrl != "") {
        qDebug() << "download: " << downloadUrl;
    } else {
        qDebug() << "empty download link for " << product;
    }

    return downloadUrl;
}

void Controller::launchInstaller(const QString &folderPath,
                                 const QString &exeName,
                                 const int &verbosity)
{
    QString installerPath = folderPath + "/" + exeName;
    qDebug() << "Launching installer:" << installerPath;

    /** 
      
    arguments that decide how the installer behaves.

    use no args to have full setup with prompts
    use /DIR= to hardcode installation dir

    ▼▼▼ !! these WILL SKIP any optional check in the gui !! ▼▼▼
    
    use /SILENT to see the installer box install stuff. no prompts, it just installs stuff.
    use /VERYSILENT for nothing at all.

    */
    QStringList arguments;

    switch (verbosity) {
    case 1:
        arguments << "/NORESTART";
        break;

    case 2:
        arguments << "/SILENT"
                  << "/NOCANCEL"
                  << "/TASKS=desktopicon"
                  << "/COMPONENTS=default";
        break;

    case 3:
    default:
        arguments << "/VERYSILENT"
                  << "/NOCANCEL"
                  << "/NORESTART"
                  << "/TASKS=desktopicon"
                  << "/COMPONENTS=full";
        break;
    }

    const int maxRetries = 5;
    const int retryDelayMs = 200;
    int attempt = 0;
    bool started = false;

    while (attempt < maxRetries) {
        started = QProcess::startDetached(installerPath, arguments);
        if (started) {
            qDebug() << "Installer started successfully on attempt" << (attempt + 1);
            break;
        }

        qWarning() << "Failed to start installer (attempt" << (attempt + 1) << ")";
        QThread::msleep(retryDelayMs);
        attempt++;
    }

    if (!started) {
        qWarning() << "All attempts to start installer failed.";
    }
}

void Controller::install(const QString &url)
{
    setLoading(true);
    cleanTempDir();
    qDebug() << "installing...";
    if (url.isEmpty()) {
        qWarning() << "No download URL found for product";
        setLoading(false);
        return;
    }

    QNetworkRequest request{QUrl(url)};
    QNetworkReply *reply = manager->get(request);

    qDebug() << "connecting...";
    qDebug() << "url:" << url;

    connect(reply,
            &QNetworkReply::downloadProgress,
            this,
            [=](qint64 bytesReceived, qint64 bytesTotal) {
                qreal progress = bytesTotal > 0 ? (qreal) bytesReceived / bytesTotal : 0;
                m_downloadProgress = progress;
                emit downloadProgressChanged(progress);
            });

    connect(reply, &QNetworkReply::finished, this, [=]() {
        if (reply->error() != QNetworkReply::NoError) {
            qWarning() << "Download failed:" << reply->errorString();
            reply->deleteLater();
            setLoading(false);
            return;
        }

        QString fileName = QUrl(url).fileName();
        if (fileName.isEmpty())
            fileName = "download.zip";
        qDebug() << "write to temp...";
        qDebug() << "fileName:" << fileName;
        QString zipPath = QStandardPaths::writableLocation(QStandardPaths::TempLocation) + "/"
                          + fileName;

        QFile file(zipPath);
        if (!file.open(QIODevice::WriteOnly)) {
            qWarning() << "Can't write zip file:" << file.errorString();
            reply->deleteLater();
            setLoading(false);
            return;
        }

        file.write(reply->readAll());
        file.close();
        reply->deleteLater();

        QString extractPath = QStandardPaths::writableLocation(QStandardPaths::TempLocation)
                              + "/extracted";
        QDir().mkpath(extractPath);
        qDebug() << "unzipping...";
        if (!unzipFile(zipPath, extractPath)) {
            qWarning() << "Unzipping failed";
            setLoading(false);
            return;
        }
        qDebug() << "launching installer...";
        QString baseName = QFileInfo(url).fileName();
        baseName.chop(8);
        QString exeName = baseName + ".exe";
        qDebug() << "exeName: " << exeName;
        launchInstaller(extractPath, exeName, 1);
        setLoading(false);
    });
}

void Controller::cleanTempDir()
{
    QString tempPath = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
    QString extractedPath = tempPath + "/extracted";

    qDebug() << "Cleaning temp files...";

    // fuck extracted
    QDir extractedDir(extractedPath);
    if (extractedDir.exists()) {
        if (!extractedDir.removeRecursively()) {
            qWarning() << "Failed to clean extracted folder";
        } else {
            qDebug() << "Removed extracted folder";
        }
    }

    // fuck zip files in temp
    QDir tempDir(tempPath);
    QStringList zipFiles = tempDir.entryList(QStringList() << "*.zip", QDir::Files);
    for (const QString &zip : zipFiles) {
        QString filePath = tempPath + "/" + zip;
        if (QFile::remove(filePath)) {
            qDebug() << "Deleted:" << filePath;
        } else {
            qWarning() << "Couldn't delete:" << filePath;
        }
    }

    // shot extracted once in the head, do it again.
    if (extractedDir.exists()) {
        QStringList exeFiles = extractedDir.entryList(QStringList() << "*.exe", QDir::Files);
        for (const QString &exe : exeFiles) {
            QString exePath = extractedPath + "/" + exe;
            if (QFile::remove(exePath)) {
                qDebug() << "Deleted lingering exe:" << exePath;
            }
        }
    }

    qDebug() << "Temp cleanup complete.";
}

void Controller::ReplyFinished(QNetworkReply *reply)
{
    QByteArray responseData = reply->readAll();
    QJsonParseError parseError;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(responseData, &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        qWarning() << "JSON parse error:" << parseError.errorString();
        reply->deleteLater();
        return;
    }

    if (!jsonDoc.isArray()) {
        qWarning() << "Expected JSON array";
        reply->deleteLater();
        return;
    }

    QJsonArray jsonArray = jsonDoc.array();

    for (const QJsonValue &val : jsonArray) {
        QJsonObject obj = val.toObject();
        Product *product = Product::fromJson(obj);
        m_model.append(product);
        emit modelChanged();
    }
    reply->deleteLater();
}
