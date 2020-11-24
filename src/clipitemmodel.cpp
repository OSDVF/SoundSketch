#include "clipitemmodel.h"

ClipItemModel::ClipItemModel(QObject *parent)
    : QObject(parent)
{
}
/*ClipItemModel::ClipItemModel(int indexInTimeline,QObject *parent):QObject(parent),m_index(indexInTimeline)
{
}
*/
qreal ClipItemModel::posMs() const
{
    return m_pos;
}
AudioFile* ClipItemModel::audioFile() const
{
    return m_file;
}
qreal ClipItemModel::durationMs() const
{
    return m_duration;
}
qreal ClipItemModel::endMs() const
{
    return m_duration + m_pos;
}
/*int ClipItemModel::index() const
{
    return m_index;
}
void ClipItemModel::setIndex(int index)
{
    if(m_index == index)
        return;
    m_index = index;
    emit indexChanged();
}
*/
