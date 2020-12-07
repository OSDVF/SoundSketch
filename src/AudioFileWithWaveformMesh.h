#ifndef AUDIFILEWITHWAVEFORMMESG_H
#define AUDIFILEWITHWAVEFORMMESG_H

#include "audiofile.h"
#include <QSGNode>
class AudioFileWithWaveformMesh: public AudioFile
{
public:
    QSGNode * waveformMeshNode = nullptr;
};

#endif // AUDIFILEWITHWAVEFORMMESG_H
