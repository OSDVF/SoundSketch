#ifndef WAVEFORMPLOT_H
#define WAVEFORMPLOT_H

#include <QObject>
#include <QQuickItem>
#include <QSGGeometry>
#include "audiofile.h"
#include "AudioFileWithWaveformMesh.h"

/**
 * @brief Displays an audio waveform represented by AudiFile's waveformBuffer
 * Use openFileAndGenerate to open an audio file or connectToFile to load a waveform from an existing file
 */
class WaveformPlot : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QColor rmsColor READ rmsColor WRITE setRmsColor NOTIFY colorsChanged)
    Q_PROPERTY(QColor peakColor READ peakColor WRITE setPeakColor NOTIFY colorsChanged)
    Q_PROPERTY(AudioFile* audioFile READ audioFile WRITE connectToFile NOTIFY audioFileChanged)
    QML_ELEMENT

public:
    AudioFile * audioFile();
    QColor rmsColor();
    QColor peakColor();
    qreal durationMs();

    void setRmsColor(QColor color);
    void setPeakColor(QColor color);
    void setBackColor(QColor color);


    WaveformPlot(QQuickItem *parent = 0);
    Q_INVOKABLE void openFileAndGenerate(QString url);
    void connectToFile(AudioFile* file);

protected:
    QSGNode *updatePaintNode(QSGNode *, UpdatePaintNodeData *);
    void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry);

signals:
    void colorsChanged();
    void audioFileChanged();

private:
    AudioFile * m_audioFile = nullptr;
    bool m_geometryChanged;
    QColor m_rmsColor = QColor(110,110,110);
    QColor m_peakColor = QColor(170,170,170);
    bool m_updateMeshWithPool = false;
    void createWaveformMesh(QSGGeometry *peaksGeometry,QSGGeometry *rmsGeometry,float width,float height);
};

#endif // WAVEFORMPLOT_H
