#ifndef CLIPLISTMODEL_H
#define CLIPLISTMODEL_H

#include <QAbstractListModel>
#include "clipitemmodel.h"
#define DEFAULT_PROJECT_DURATION 50000.0

class ClipListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(qreal totalDurationMs READ totalDurationMs NOTIFY totalDurationMsChanged)

public:
    enum ModelRoles {
        PosMsRole = Qt::UserRole + 1,
        DurationMsRole,
        EndMsRole,
        AudioFileRole
    };
    explicit ClipListModel(QObject *parent = nullptr);

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    // Editable:
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;

    Q_INVOKABLE void append(qreal posMs, QString audioFileName);
    Q_INVOKABLE void remove(int index);
    Q_INVOKABLE QObject* get(int index) const;
    /**
     * @brief Recalculates positions of surrounding items.
     * @param index Index of item which is repositioned
     * @param newPos New item position
     * @param swapSiblings When true the repositioned item might be swapped with one of its siblings when the newPos is away enough
     * @returns [int] Index of the most distant item that has been repositioned. -1 when no reposition occured
     * @attention If newPos is further than any of repositioned item's closest surrounding items, the algorithm will not output correct results
     */
    Q_INVOKABLE int reposition(int index, qreal newPos, ClipListModel *previewList, bool swapSiblings = true);
    Q_INVOKABLE ClipListModel * copy();
    Q_INVOKABLE void copyTo(ClipListModel* list);
    Q_INVOKABLE void clear();
    Q_INVOKABLE int getIndexOfItemAtPos(qreal pos);

    QHash<int, QByteArray> roleNames() const override
    {
        static QHash<int, QByteArray> *pHash;
        if (!pHash) {
            pHash = new QHash<int, QByteArray>;
            (*pHash)[Qt::UserRole + 1] = "clipItemModel";
        }
        return *pHash;
    }

    int count() const;
    qreal totalDurationMs() const;

signals:
    void countChanged(int count);
    void totalDurationMsChanged();

private:
    QList<ClipItemModel* > m_list;
    int m_count = 0;
    void swapItems(int leftIndex, int index);
    int getIndexForNewItem(qreal posMs, qreal duration);
    qreal getCorrectPosForNewItem(qreal posMs, qreal duration, int requestedIndex);
};

#endif // CLIPLISTMODEL_H
