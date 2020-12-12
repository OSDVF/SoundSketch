#include "player.h"

#include <QAudioFormat>
#include <iostream>

player::player(QObject* parent)
: QObject(parent), playing(false)
{

}

player::~player()
{
    this->stop();
}

void player::play(AudioFile* audio, unsigned offset_ms)
{
    if(playing)
    {
        delete audio_out;
        delete buffer;
    }

    QAudioFormat format;
    format.setCodec("audio/pcm");
    format.setChannelCount(2);
    format.setSampleSize(16);
    format.setByteOrder(QAudioFormat::LittleEndian);
    format.setSampleType(QAudioFormat::SignedInt);
    format.setSampleRate(44100/4);

    buffer = new QBuffer(&audio->waveformBuffer);
    buffer->open(QIODevice::ReadOnly);
    buffer->seek((offset_ms/audio->durationMs())*buffer->size());

    audio_out = new QAudioOutput(format, this);
    connect(audio_out, SIGNAL(stateChanged(QAudio::State)), this, SLOT(state_changed(QAudio::State)));
    connect(audio_out, SIGNAL(notify()), this, SLOT(notify_slot()));

    audio_len_ms = audio->durationMs();

    audio_out->setNotifyInterval(100);
    audio_out->setVolume(50);
    audio_out->start(buffer);
    playing = true;
}

void player::stop()
{
    if(playing)
    {
        delete audio_out;
        delete buffer;
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
