#ifndef CLIPITEMMODEL_H
#define CLIPITEMMODEL_H

#include "audiofile.h"
#include <QObject>

class ClipItemModel:QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal posMs READ posMs WRITE setPosMs NOTIFY posMsChanged)
    Q_PROPERTY(qreal durationMs READ durationMs NOTIFY audioFileChanged STORED false)
    Q_PROPERTY(qreal endMs READ endMs NOTIFY endMsChanged STORED false)
    Q_PROPERTY(AudioFile* audioFile READ audioFile WRITE setAudioFile NOTIFY audioFileChanged)
    //Q_PROPERTY(int m_index READ index NOTIFY indexChanged)

public:
    ClipItemModel(QObject *parent = nullptr);
    //explicit ClipItemModel(int indexInTimeline,QObject *parent = nullptr);

    qreal posMs() const;
    qreal durationMs() const;
    qreal endMs() const;

    AudioFile* audioFile() const;
    //int index() const;

    void setPosMs(qreal value)
    {
        if(m_pos == value)
            return;
        m_pos = value;
        emit posMsChanged();
    }
    void setAudioFile(AudioFile* value);

    ClipItemModel *clone();

signals:
    void posMsChanged();
    void endMsChanged();
    void audioFileChanged();
    //void indexChanged();
private:
    qreal m_pos = 0;
    qreal m_duration = 0;
    AudioFile* m_file = nullptr;
    //int m_index;
    //void setIndex(int index);
    friend class ClipListModel;
};

#endif // CLIPITEMMODEL_H
