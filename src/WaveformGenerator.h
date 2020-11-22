#ifndef DECODEAUDIO_H
#define DECODEAUDIO_H
#include <QString>
#include <string>
#include <QDebug>
#include <string>

#include "ffmpegcpp.h"
using namespace ffmpegcpp;

/**
 * @brief Generates waverom buffer and outputs duration of imported sound.
 * @example WaveformGenerator::generateFrom(path,byteArray,duration_ms)
 */
class WaveformGenerator : public AudioFrameSink, public FrameWriter
{
public:
    static void generateFrom(QString path,QByteArray& byteArray)
    {
        try
        {
            std::string str = path.toStdString();
            const char* p = str.c_str();
            Demuxer *demuxer = new Demuxer(p);
            generateFromStream(demuxer,byteArray);

        }
        catch (const FFmpegException& e)
        {
            qDebug() << "Exception caught!";
            qDebug() << e.what();//log and..
            throw e;//rethrow
        }
    }
    static void openFile(QString path,QByteArray& byteArray,qreal& duration)
    {
        try
        {
            std::string str = path.toStdString();
            const char* p = str.c_str();
            Demuxer *demuxer = new Demuxer(p);
            ContainerInfo info = demuxer->GetInfo();
            duration = info.durationInMicroSeconds / 1000;
            generateFromStream(demuxer,byteArray);
        }
        catch (const FFmpegException& e)
        {
            qDebug() << "Exception caught!";
            qDebug() << e.what();//log and..
            throw e;//rethrow
        }
    }
private:
    static void generateFromStream(Demuxer * demuxer,QByteArray& byteArray)
    {
        WaveformGenerator sink(byteArray);
        const char *fname = demuxer->GetFileName();

        int stream = av_find_best_stream(demuxer->containerContext, AVMEDIA_TYPE_AUDIO, -1, -1, NULL, 0);
        if (stream < 0)
        {
            throw FFmpegException("Could not find " + std::string(av_get_media_type_string(AVMEDIA_TYPE_AUDIO)) + " stream in input file " + std::string(fname), stream);
        }
        //Extract information
        sink.setFrameCount(demuxer->GetFrameCount(stream));
        delete demuxer;//We need to clean up

        demuxer = new Demuxer(fname);
        demuxer->DecodeAudioStream(stream,&sink);
        // tie the file sink to the best audio stream in the input container.

        // Prepare the output pipeline. This will push a small amount of frames to the file sink until it IsPrimed returns true.
        demuxer->PreparePipeline();
        // Push all the remaining frames through.
        while (!demuxer->IsDone())
        {
            demuxer->Step();
        }

        // done
        byteArray.resize(sink.bufferIndex);
        delete demuxer;
    }

protected:
    WaveformGenerator(QByteArray& byteArray):byteArray(byteArray) {
    }
    ~WaveformGenerator()
    {
        if(stream != nullptr)
            delete stream;
    }

    FrameSinkStream* CreateStream()
    {
        stream = new FrameSinkStream(this, 0);
        return stream;
    }

    virtual void WriteFrame(int /* unused */, AVFrame* frame, StreamData* /* unused */)
    {
        AVSampleFormat format = (AVSampleFormat)frame->format;
        int data_size = av_get_bytes_per_sample(format);
        if(!bufferSetup)
        {
            auto samplePerFrame = frame->nb_samples;
            byteArray.resize(frameCount*data_size*samplePerFrame);
            bufferSetup = true;
            qDebug() << "Frame count: " << frameCount << " Data size: "<< data_size << " Samples per frame: "<<samplePerFrame;
            qDebug() << "Buffer size: " << byteArray.size();
        }
        for (int i = 0; i < frame->nb_samples; i++)
        {
            signed char sample = -128;
            switch (format) {
            case AVSampleFormat::AV_SAMPLE_FMT_DBLP:
                sample = *((double*)frame->data[0] + i)*127;
                break;
            case AVSampleFormat::AV_SAMPLE_FMT_FLTP:
                sample = *((float*)frame->data[0] +  i)*127;
                break;
            case AVSampleFormat::AV_SAMPLE_FMT_S16P:
                sample = *((signed short*)frame->data[0] + i)/2;
                break;

            case AVSampleFormat::AV_SAMPLE_FMT_U8P:
                sample = *((unsigned char*)frame->data[0] + i) - 128;
                break;
            case AVSampleFormat::AV_SAMPLE_FMT_S32P:
                sample = *((signed int*)frame->data[0] + i)/2 - (INT_MAX/2);
                break;
            case AVSampleFormat::AV_SAMPLE_FMT_S64P:
                sample = *((signed long int*)frame->data[0] +  i)/2 - (LONG_MAX/2);
                break;
                //Interleaved
            case AVSampleFormat::AV_SAMPLE_FMT_DBL:
                sample = *((double*)frame->data[0] +  i*2)*127;
                break;
            case AVSampleFormat::AV_SAMPLE_FMT_FLT:
                sample = *((float*)frame->data[0] +  i*2)*127;
                break;
            case AVSampleFormat::AV_SAMPLE_FMT_S16:
                sample = *((signed short*)frame->data[0] + i*2)/2;
                break;

            case AVSampleFormat::AV_SAMPLE_FMT_U8:
                sample = *((unsigned char*)frame->data[0] + i*2) - 128;
                break;
            case AVSampleFormat::AV_SAMPLE_FMT_S32:
                sample = *((signed int*)frame->data[0] + i*2)/2 - (INT_MAX/2);
                break;
            case AVSampleFormat::AV_SAMPLE_FMT_S64:
                sample = *((signed long int*)frame->data[0] + i*2)/2 - (LONG_MAX/2);
                break;
            default:
                qDebug() << "error";
                break;
            }
            auto arrSize = byteArray.size();
            if(bufferIndex >= arrSize)
            {
                qDebug() << frameCount <<"/"<< processedFrames;
                byteArray.resize(arrSize + (frameCount - processedFrames)*frame->nb_samples);
            }
            byteArray.data()[bufferIndex++] = sample;
        }
        processedFrames++;
    }

    virtual void Close( int /* unused */)
    {
        delete stream;
        stream = nullptr;
    }

    virtual bool IsPrimed()
    {
        // Return whether we have all information we need to start writing out data.
        // Since we don't really need any data in this use case, we are always ready.
        // A container might only be primed once it received at least one frame from each source
        // it will be muxing together
        return true;
    }

    void setFrameCount(int c)
    {
        frameCount = c;
    }

private:
    FrameSinkStream* stream = nullptr;
    QByteArray& byteArray;
    int frameCount;
    int processedFrames = 0;
    bool bufferSetup = false;
    int bufferIndex = 0;
};


#endif // DECODEAUDIO_H
