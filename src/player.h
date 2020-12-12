#ifndef PLAYER_H
#define PLAYER_H

#include <QObject>
#include <QtQuick>
#include <QAudioOutput>
#include <QBuffer>
#include "audiofile.h"

class player : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int audio_pos_from_start READ get_audio_pos_from_start WRITE set_audio_pos_from_start)
    QML_ELEMENT
public:
    player(QObject* parent = nullptr);
    ~player();

    int get_audio_pos_from_start() { return audio_pos_from_start; }
    void set_audio_pos_from_start(int id) { audio_pos_from_start = id; }
signals:
    void set_pos_ms(int pos_ms);
    void done();
public slots:
    Q_INVOKABLE void play(AudioFile* audio, unsigned offset_ms);
    Q_INVOKABLE void stop();
private slots:
    void state_changed(QAudio::State);
    void notify_slot();
private:
    QAudioOutput* audio_out;
    QBuffer* buffer;
    quint64 audio_len_ms;
    bool playing;
    int audio_pos_from_start;
};

#endif // PLAYER_H
