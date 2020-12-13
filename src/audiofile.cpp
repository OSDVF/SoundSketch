#include "audiofile.h"
#include <QUrl>
#include "WaveformGenerator.h"



AudioFile::AudioFile(QObject *parent) : QObject(parent)
{

}

AudioFile* AudioFile::create(QString fileUrl)
{
    AudioFile *newFile = new AudioFile();
    newFile->openFileUrl(fileUrl);
    return newFile;
}

qreal AudioFile::startMs() const
{
    return m_start;
}

qreal AudioFile::endMs() const
{
    return m_end;
}

void AudioFile::setStart(qreal start)
{
    if(start == m_start)
        return;

    m_start = start;
    emit startMsChanged();
}

void AudioFile::setEnd(qreal end)
{
    if(end == m_end)
        return;
    m_end = end;
    emit endMsChanged();
}

QString AudioFile::fileUrl(){
    return m_filePath;
}
qreal AudioFile::durationMs() const
{
    return m_duration;
}

bool AudioFile::hasException()
{
    return m_exception;
}

QString AudioFile::exception()
{
    return m_exceptionMessage;
}

int AudioFile::frameCount()
{
    return m_frames;
}

int AudioFile::streamId()
{
    return m_audioStreamId;
}

int AudioFile::streamIndex()
{
    return m_audioStreamIndex;
}
qreal AudioFile::bitrate()
{
    return m_bitrate;
}
QString AudioFile::baseName()
{
    return m_baseName;
}
QString AudioFile::format()
{
    return m_format;
}
void AudioFile::openFileUrl(QString url){
    if(m_filePath == url)
        return;

    m_filePath = url;
    m_duration = 5000;
    auto baseNamePos = m_filePath.lastIndexOf('/')+1;
    int dotPos = m_filePath.lastIndexOf('.');
    m_format = m_filePath.mid(dotPos+1);
    
    dotPos -= baseNamePos;
    m_baseName = m_filePath.mid(baseNamePos, dotPos);
    
    m_start = 0;
    m_end = m_duration;

    emit fileUrlChanged();
    emit endMsChanged();
    emit startMsChanged();
}

void AudioFile::clearException()
{
    if(m_exception)
    {
        m_exception = false;
        emit exceptionChanged();
    }
}

void AudioFile::loadWaveform()
{
    try
    {
        WaveformGenerator::generateFrom(m_filePath,waveformBuffer);
        clearException();
    }
    catch(const std::exception& e)
    {
        m_exception = true;
        qDebug() << "Exception when generating waveform:";
        processException(e);
    }
}

void AudioFile::processException(const std::exception &e)
{
    auto hadEx = m_exception;
    m_exception = true;
    m_exceptionMessage = QString(e.what());
    qDebug() << m_exceptionMessage;
    if(hadEx)
        emit exceptionChanged();
}
