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
    /*if (!index.isValid())
        return QVariant();

    if(role == Qt::DisplayRole)
        switch (index.column())
        {
        case 0:
            return m_list[index.row()]->m_pos;
        case 1:
            return m_list[index.row()]->durationMs();
        case 2:
            return m_list[index.row()]->endMs();
        case 3:
            return QVariant::fromValue(static_cast<QObject*>(m_list[index.row()]->m_file));
        }
    return QVariant();*/
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
    int i = m_list.size();
    beginInsertRows(QModelIndex(), i, i);
    auto file = new AudioFile();
    file->setFileUrl(audioFileName);
    auto newItem = new ClipItemModel();
    newItem->setAudioFile(file);
    newItem->m_pos = posMs;
    m_list.append(newItem);
    m_count++;
    endInsertRows();
    emit countChanged(m_count);
    emit totalDurationMsChanged();
    //emit dataChanged(createIndex(len,0), createIndex(len,3));
}

void ClipListModel::remove(int index)
{
    beginRemoveRows(QModelIndex(),index,--m_count);
    delete m_list[index];
    m_list.removeAt(index);
    emit countChanged(m_count);
    emit totalDurationMsChanged();
    endRemoveRows();
}
QObject* ClipListModel::get(int index) const
{
   /* auto map = QVariantMap();
    auto item = m_list[index];
    auto durationMs = item->durationMs();
    map["posMs"] = item->m_pos;
    map["durationMs"] = durationMs;
    map["endMs"] = durationMs + item->m_pos;
    map["audioFile"] = QVariant::fromValue(static_cast<QObject*>(m_list[index]->m_file));
    return map;*/
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
        /*switch (index.column())
        {
        case 0:
            m_list[index.row()]->setPosMs(value.toReal());
            emit dataChanged(index, index, QVector<int>() << role);
            return true;
        case 1:
        case 2:
            return false;
        case 3:
            m_list[index.row()]->setAudioFile(static_cast<AudioFile*>(value.value<QObject*>()));
            emit dataChanged(index, index, QVector<int>() << role);
            return true;
        }*/
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
