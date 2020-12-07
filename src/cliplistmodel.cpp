#include "cliplistmodel.h"
#include <qqmlprivate.h>

ClipListModel::ClipListModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int ClipListModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return m_count;
}

QVariant ClipListModel::data(const QModelIndex &index, int role) const
{
    Q_UNUSED(role)
    return QVariant::fromValue(static_cast<QObject*>(m_list[index.row()]));
}
qreal ClipListModel::totalDurationMs() const
{
    if(m_count != 0)
    {
        return m_list[m_count-1]->endMs();
    }
    else
        return DEFAULT_PROJECT_DURATION;
}

void ClipListModel::append(qreal posMs, QString audioFileName)
{
    auto file = new AudioFile();
    file->openFileUrl(audioFileName);
    auto newItem = new ClipItemModel();
    newItem->setAudioFile(file);
    newItem->m_pos = posMs;

    int newIndex = getIndexForNewItem(posMs);
    emit layoutAboutToBeChanged();
    m_list.insert(newIndex, newItem);

    m_count++;
    emit layoutChanged();
    emit countChanged(m_count);
    emit totalDurationMsChanged();
}

int ClipListModel::getIndexForNewItem(qreal posMs)
{
    for(int i =0; i<m_count;i++)
    {
        if(m_list[i]->m_pos > posMs)
        {
            return i;
        }
    }
}

void ClipListModel::remove(int index)
{
    beginRemoveRows(QModelIndex(),index,m_count-1);
    m_list.removeAt(index);
    emit countChanged(--m_count);
    emit totalDurationMsChanged();
    endRemoveRows();
}

void ClipListModel::swapItems(int leftIndex, int index)
{
    auto swapTemp = m_list[leftIndex];
    /*auto swapTempFile = swapTemp->m_file;

    m_list[leftIndex]->setAudioFile(m_list[index]->m_file);
    m_list[index]->setAudioFile(swapTempFile);*/

    m_list[leftIndex] = m_list[index];
    m_list[index] = swapTemp;
}

ClipListModel *ClipListModel::copy()
{
    ClipListModel *newList = new ClipListModel();
    copyTo(newList);
    return newList;
}

void ClipListModel::copyTo(ClipListModel *newList)
{
    newList->m_list.reserve(m_count);
    newList->m_list.clear();
    for(int i=0; i<m_count; i++)
    {
        auto clone = m_list[i]->clone();
        newList->m_list.append(clone);
    }
    newList->m_count = m_count;
}

void ClipListModel::clear()
{
    for(int i=0; i<m_count; i++)
    {
        delete m_list[i];
    }
    m_count = 0;
    m_list.clear();
    emit countChanged(m_count);
}

int ClipListModel::reposition(int index, qreal newPos, ClipListModel *previewList, bool swapWithSiblings)
{
    auto leftIndex = index - 1;
    auto rightIndex = index + 1;
    ClipItemModel * thisItem = m_list[index];
    QList<ClipItemModel *>* preview = &previewList->m_list;
    if(leftIndex>0)
    {
        //Correct positioning
        ClipItemModel * leftItem = preview->at(leftIndex);
        if(leftItem->m_pos>newPos)
        {
            emit layoutAboutToBeChanged();
            //previewList->beginMoveRows(QModelIndex(),index,index,QModelIndex(),rightIndex);//Moves before the rightIndex
            previewList->swapItems(leftIndex,index);
            //endMoveRows();
            emit layoutChanged();

            index--;
            leftIndex = index - 1;
            rightIndex--;
        }
    }
    if(rightIndex < m_count)
    {
        //Correct positioning
        ClipItemModel * rightItem = preview->at(rightIndex);
        if(rightItem->m_pos<newPos)
        {
            //previewList->beginMoveRows(QModelIndex(),index,index,QModelIndex(),index);//Moves left
            emit layoutAboutToBeChanged();
            previewList->swapItems(rightIndex,index);
            //previewList->endMoveRows();
            emit layoutChanged();

            index++;
            leftIndex = index - 1;
            rightIndex++;
        }
    }
    return 0;
}

QObject* ClipListModel::get(int index) const
{
    Q_ASSERT(index >= 0 && index < m_count);
    return m_list[index];
}
int ClipListModel::count() const
{
    return m_count;
}

bool ClipListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (data(index, role) != value)
    {
        m_list[index.row()] = static_cast<ClipItemModel*>(value.value<QObject*>());
        return true;
    }
    return false;
}

Qt::ItemFlags ClipListModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}
