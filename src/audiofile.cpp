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

QString AudioFile::fileUrl(){
    return m_filePath;
}
qreal AudioFile::durationMs()
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
    std::string stdStr = m_filePath.toStdString();
    const char* fname = stdStr.c_str();
    try
    {
        /*Demuxer* demuxer = new Demuxer(fname);
        ContainerInfo info = demuxer->GetInfo();

        m_duration = info.durationInMicroSeconds / 1000;
        m_bitrate = info.bitRate;

        auto baseNamePos = m_filePath.lastIndexOf('/')+1;
        m_baseName = m_filePath.mid(baseNamePos);
        m_format = QString(info.format->name);

        //Stream info extraction
        m_audioStreamIndex = av_find_best_stream(demuxer->containerContext, AVMEDIA_TYPE_AUDIO, -1, -1, NULL, 0);//Returns stream index
        if (m_audioStreamIndex < 0)
        {
            if(demuxer != nullptr)
                delete demuxer;
            throw FFmpegException(std::string("Could not find ") + av_get_media_type_string(AVMEDIA_TYPE_AUDIO) + " stream in input file " + stdStr,m_audioStreamIndex);
        }
        m_audioStreamId = demuxer->containerContext->streams[m_audioStreamIndex]->id;//But we need the stream id too
        m_frames = demuxer->GetFrameCount(m_audioStreamId);//Will process entire stream!
        clearException();
        if(demuxer != nullptr)
            delete demuxer;*/
    }
    catch (const std::exception& e)
    {
        qDebug() << "Exception when opening audio file:";
        processException(e);
    }

    emit fileUrlChanged();
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
