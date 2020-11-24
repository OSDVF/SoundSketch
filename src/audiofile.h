#ifndef AUDIOFILE_H
#define AUDIOFILE_H

#include <QObject>
#include <QtQuick>
#include "ffmpegcpp.h"
using namespace ffmpegcpp;

/**
 * @brief Hold properties of an audio file container
 */
class AudioFile : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString fileUrl READ fileUrl WRITE setFileUrl NOTIFY fileUrlChanged REQUIRED)
    Q_PROPERTY(long durationUs READ durationUs NOTIFY fileUrlChanged STORED false)
    Q_PROPERTY(qreal bitrate READ bitrate NOTIFY fileUrlChanged STORED false)
    Q_PROPERTY(QString baseName READ baseName NOTIFY fileUrlChanged STORED false)
    Q_PROPERTY(QString format READ format NOTIFY fileUrlChanged STORED false)

    QML_ELEMENT
public:
    explicit AudioFile(QObject *parent = nullptr);

    long durationUs();
    qreal bitrate();
    QString fileUrl();
    QString format();
    QString baseName();
    void setFileUrl(QString url);
signals:
    void fileUrlChanged();
private:
    QString m_fileUrl;
    QString m_format;
    QString m_baseName;
    long m_duration;
    qreal m_bitrate;
};

#endif // AUDIOFILE_H
