#include "clipitemmodel.h"

ClipItemModel::ClipItemModel(QObject *parent)
    : QObject(parent)
{
}
qreal ClipItemModel::posMs() const
{
    return m_pos;
}
AudioFile* ClipItemModel::audioFile() const
{
    return m_file;
}

void ClipItemModel::setAudioFile(AudioFile *value)
{
    if(m_file == value)
        return;
    m_file = value;
    m_duration = m_file->durationMs();
    emit audioFileChanged();

}
qreal ClipItemModel::durationMs() const
{
    return m_duration;
}
qreal ClipItemModel::endMs() const
{
    return m_duration + m_pos;
}

ClipItemModel * ClipItemModel::clone()
{
    ClipItemModel *newClip = new ClipItemModel(parent());
    newClip->m_pos = m_pos;
    newClip->m_duration = m_duration;
    newClip->m_file = m_file;
    return newClip;
}
