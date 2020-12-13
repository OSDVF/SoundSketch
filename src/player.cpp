#include "player.h"

#include <QAudioFormat>
#include <iostream>
#include <unordered_map>

std::unordered_map<QString, QBuffer*> audio_buffer_table;

player::player(QObject* parent)
: QObject(parent), playing(false)
{
    QAudioFormat format;
    format.setCodec("audio/pcm");
    format.setChannelCount(2);
    format.setSampleSize(16);
    format.setByteOrder(QAudioFormat::LittleEndian);
    format.setSampleType(QAudioFormat::SignedInt);
    format.setSampleRate(44100/4);

    audio_out = new QAudioOutput(format, this);
    connect(audio_out, SIGNAL(stateChanged(QAudio::State)), this, SLOT(state_changed(QAudio::State)));
    connect(audio_out, SIGNAL(notify()), this, SLOT(notify_slot()));

    audio_out->setNotifyInterval(100);
    audio_out->setVolume(50);
}

player::~player()
{
    this->stop();
    delete audio_out;
    for(auto p : audio_buffer_table)
        delete p.second;
}

void player::play(AudioFile* audio, unsigned offset_ms)
{
    if(playing)
        this->stop();

    if(audio_buffer_table.find(audio->baseName()) == audio_buffer_table.end())
        audio_buffer_table[audio->baseName()] = new QBuffer(&audio->waveformBuffer);

    buffer = audio_buffer_table[audio->baseName()];
    buffer->open(QIODevice::ReadOnly);
    buffer->seek((offset_ms/audio->durationMs())*buffer->size());

    audio_len_ms = audio->durationMs();

    audio_out->start(buffer);
    playing = true;
}

void player::stop()
{
    if(playing)
    {
        audio_out->stop();
        buffer->close();
        playing = false;
    }
}

void player::state_changed(QAudio::State state)
{
    if(state == QAudio::State::IdleState)
        emit done();
}

void player::notify_slot()
{
    if(playing)
        emit set_pos_ms((buffer->pos()/qreal(buffer->size()))*audio_len_ms);
}
