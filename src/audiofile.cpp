#include "audiofile.h"
#include <QUrl>
#include <QStringRef>

AudioFile::AudioFile(QObject *parent) : QObject(parent)
{

}

QString AudioFile::fileUrl(){
    return m_fileUrl;
}
long AudioFile::durationUs()
{
    return m_duration;
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
void AudioFile::setFileUrl(QString url){
    if(m_fileUrl == url)
        return;

    m_fileUrl = url;
    QString local = QUrl(url).toLocalFile();
    std::string stdStr = local.toStdString();
    Demuxer* demuxer = new Demuxer(stdStr.c_str());
    ContainerInfo info = demuxer->GetInfo();

    m_duration = info.durationInMicroSeconds;
    m_bitrate = info.bitRate;
    auto baseNamePos = local.lastIndexOf('/')+1;
    m_baseName = local.mid(baseNamePos);
    m_format = QString(info.format->name);
    delete demuxer;
    emit fileUrlChanged();
}

