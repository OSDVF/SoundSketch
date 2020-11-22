#ifndef WAVEFORMPLOT_H
#define WAVEFORMPLOT_H

#include <QObject>
#include <QQuickItem>
#include <QSGGeometry>
#include "audiofile.h"

/**
 * @brief Displays an audio waveform represented by 8byte values in the samples property.
 * Use openFile() to open an audio file.
 * @note Uses ffmepg internally to generate the waveforms
 */
class WaveformPlot : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QByteArray samples READ samples WRITE setSamples NOTIFY samplesUpdated)
    Q_PROPERTY(QColor rmsColor READ rmsColor WRITE setRmsColor NOTIFY colorsChanged)
    Q_PROPERTY(QColor peakColor READ peakColor WRITE setPeakColor NOTIFY colorsChanged)
    Q_PROPERTY(qreal durationMs READ durationMs NOTIFY durationUpdated)
    Q_PROPERTY(bool hasException READ hasException NOTIFY exceptionChanged)
    Q_PROPERTY(QString exception READ exception NOTIFY exceptionChanged)
    QML_ELEMENT

public:

    QByteArray samples();
    void setSamples(QByteArray byteArray);

    QColor rmsColor();
    QColor peakColor();
    qreal durationMs();
    QString exception();
    bool hasException();

    void setRmsColor(QColor color);
    void setPeakColor(QColor color);
    void setBackColor(QColor color);


    WaveformPlot(QQuickItem *parent = 0);
    Q_INVOKABLE void openFile(QString url);
    Q_INVOKABLE void loadOpenedFile(AudioFile* file);

protected:
    QSGNode *updatePaintNode(QSGNode *, UpdatePaintNodeData *);
    void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry);

signals:
    /**
     * @brief Emitted right after a file is imported but before the control is redrawn
     */
    void samplesUpdated();
    /**
     * @brief Emitted right after a file is imported but before the control is redrawn
     */
    void durationUpdated();
    void exceptionChanged();
    void colorsChanged();

private:
    QByteArray m_samples;
    bool m_geometryChanged;
    QColor m_rmsColor = QColor(110,110,110);
    QColor m_peakColor = QColor(170,170,170);
    qreal m_duration;
    //Indicates an exception while opening the file
    bool m_exception;
    QString m_exceptionMessage;
    void createWaveformMesh(QSGGeometry *peaksGeometry,QSGGeometry *rmsGeometry,float width,float height);
};

#endif // WAVEFORMPLOT_H
