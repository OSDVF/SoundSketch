#ifndef RECORDER_H
#define RECORDER_H

#include <QMainWindow>
#include <QMediaRecorder>
#include <QUrl>
#include <QObject>
#include <QtQuick>

QT_BEGIN_NAMESPACE
namespace Ui { class AudioRecorder; }
class QAudioRecorder;
class QAudioProbe;
class QAudioBuffer;
QT_END_NAMESPACE

class AudioLevel;

class AudioRecorder : public QObject
{
    Q_OBJECT

public:
    AudioRecorder();
    Q_INVOKABLE void updateStatus(QMediaRecorder::Status);

public slots:
    void processBuffer(const QAudioBuffer&);


private slots:
    void setOutputLocation();
    void togglePause();
    void toggleRecord();


    void onStateChanged(QMediaRecorder::State);
    void updateProgress(qint64 pos);
    void displayErrorMessage();

private:
    void clearAudioLevels();

    Ui::AudioRecorder *ui = nullptr;

    QAudioRecorder *m_audioRecorder = nullptr;
    QAudioProbe *m_probe = nullptr;
    QList<AudioLevel*> m_audioLevels;
    bool m_outputLocationSet = false;
    QML_ELEMENT
};
#endif // RECORDER_H
