#ifndef AUDIOFILE_H
#define AUDIOFILE_H

#include <QObject>
#include <QtQuick>
#include <QByteArray>

/**
 * @brief Hold properties of an audio file container
 */
class AudioFile : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString fileUrl READ fileUrl WRITE openFileUrl NOTIFY fileUrlChanged REQUIRED)
    Q_PROPERTY(qreal durationMs READ durationMs NOTIFY fileUrlChanged STORED false)
    Q_PROPERTY(qreal bitrate READ bitrate NOTIFY fileUrlChanged STORED false)
    Q_PROPERTY(QString baseName READ baseName NOTIFY fileUrlChanged STORED false)
    Q_PROPERTY(QString format READ format NOTIFY fileUrlChanged STORED false)
    Q_PROPERTY(int frameCount READ frameCount NOTIFY fileUrlChanged STORED false)
    Q_PROPERTY(int streamId READ streamId NOTIFY fileUrlChanged STORED false)
    Q_PROPERTY(int streamIndex READ streamIndex NOTIFY fileUrlChanged STORED false)
    Q_PROPERTY(QByteArray waveformBuffer MEMBER waveformBuffer STORED false)

    Q_PROPERTY(bool hasException READ hasException NOTIFY exceptionChanged)
    Q_PROPERTY(QString exception READ exception NOTIFY exceptionChanged)

    QML_ELEMENT
public:
    explicit AudioFile(QObject *parent = nullptr);

    qreal durationMs();
    int frameCount();
    int streamId();
    int streamIndex();
    qreal bitrate();
    QString fileUrl();
    QString format();
    QString baseName();
    bool hasException();
    QString exception();
    void openFileUrl(QString url);
    Q_INVOKABLE void loadWaveform();
    QByteArray waveformBuffer;
signals:
    void fileUrlChanged();
    void exceptionChanged();
private:
    QString m_filePath;
    QString m_format;
    QString m_baseName;
    qreal m_duration = 0;
    int m_frames = 0;
    qreal m_bitrate = 0;
    int m_audioStreamId = 0;
    int m_audioStreamIndex = 0;
    bool m_exception = false;
    QString m_exceptionMessage;

    void processException(const std::exception& e);
    void clearException();
};

#endif // AUDIOFILE_H
