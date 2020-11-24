#include "waveformplot.h"
#include <QSGGeometry>
#include <QSGFlatColorMaterial>
#include <QSGGeometryNode>
#include <QSGSimpleRectNode>
#include <QUrl>
#include "WaveformGenerator.h"
#include <algorithm> //for std::min

WaveformPlot::WaveformPlot(QQuickItem *parent):QQuickItem(parent), m_geometryChanged(false)
{
    setFlag(ItemHasContents, true);
}

qreal WaveformPlot::durationMs()
{
    return m_duration;
}

bool WaveformPlot::hasException()
{
    return m_exception;
}

QString WaveformPlot::exception()
{
    return m_exceptionMessage;
}

QColor WaveformPlot::rmsColor()
{
    return m_rmsColor;
}

QColor WaveformPlot::peakColor()
{
    return m_peakColor;
}

void WaveformPlot::setRmsColor(QColor color)
{
    if(m_rmsColor != color)
    {
        m_rmsColor = color;
        emit colorsChanged();
    }
    if(!m_geometryChanged)
    {
        m_geometryChanged = true;
        update();
    }
}
void WaveformPlot::setPeakColor(QColor color)
{
    if(m_peakColor != color)
    {
        m_peakColor = color;
        emit colorsChanged();
    }
    if(!m_geometryChanged)
    {
        m_geometryChanged = true;
        update();
    }
}

QByteArray WaveformPlot::samples()
{
    return m_samples;
}
void WaveformPlot::setSamples(QByteArray byteArray)
{
    if(m_samples == byteArray)
        return;
    m_samples = byteArray;
    emit samplesUpdated();
}

void WaveformPlot::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    m_geometryChanged = true;
    update();
    QQuickItem::geometryChanged(newGeometry, oldGeometry);
}


void WaveformPlot::createWaveformMesh(QSGGeometry *peaksGeometry,QSGGeometry *rmsGeometry,float width,float height)
{
    peaksGeometry->setDrawingMode(GL_LINES);
    peaksGeometry->setLineWidth(1);
    rmsGeometry->setDrawingMode(GL_LINES);
    rmsGeometry->setLineWidth(1);

    auto peaksVertices = peaksGeometry->vertexDataAsPoint2D();
    auto rmsVertieces = rmsGeometry->vertexDataAsPoint2D();

    float zeroY = height/2;
    auto samplesCount = m_samples.size();
    auto samplesPerPixel = (samplesCount/width);
    int maxVerticeIndex = width * 2;

    for(int i = 0;i<width;i++)
    {
        int minIndex = (int)(samplesPerPixel *i);
        int maxIndex = std::min<int>(minIndex + samplesPerPixel,samplesCount);
        //For peak sample
        char maxSample = CHAR_MIN;
        //For RMS sample
        float meanSample = 0;
        for(int s = minIndex;s<maxIndex;s++)
        {
            auto singleSample = m_samples.constData()[s];
            if(singleSample>maxSample) maxSample = singleSample;
            meanSample += singleSample*singleSample;
        }
        auto normalizationConst = (zeroY/(CHAR_MAX*2));
        float normalized = maxSample * normalizationConst;
        auto firstVerticeIndex = (i*2)% maxVerticeIndex;
        auto secondVerticeIndex = ((i*2)+1 )% maxVerticeIndex;
        //Draw peaks
        peaksVertices[firstVerticeIndex].set(i,zeroY-normalized);
        peaksVertices[secondVerticeIndex].set(i,zeroY+normalized);

        meanSample = sqrtf(meanSample/samplesPerPixel);
        normalized = meanSample * normalizationConst;
        //Draw RMS
        rmsVertieces[firstVerticeIndex].set(i,zeroY-normalized);
        rmsVertieces[secondVerticeIndex].set(i,zeroY+normalized);
    }
}

QSGNode *WaveformPlot::updatePaintNode(QSGNode *parentNode, UpdatePaintNodeData *)
{
    QRectF rect = boundingRect();
    if (rect.isEmpty()) {
        delete parentNode;
        return nullptr;
    }
    QSGGeometry *peaksGeometry;
    QSGGeometry *rmsGeometry;
    QSGGeometryNode *peaksNode;
    QSGGeometryNode *rmsNode;

    QSizeF itemSize = size();
    float width = itemSize.width();
    float height = itemSize.height();
    auto linesVertexCount = width *2 ;
    if(!parentNode)
    {
        parentNode = new QSGNode;

        //Create nodes, materials, geometry and background rectangle
        peaksNode = new QSGGeometryNode;
        rmsNode = new QSGGeometryNode;
        rmsGeometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), linesVertexCount);
        peaksGeometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), linesVertexCount);

        QSGFlatColorMaterial *peaksMaterial = new QSGFlatColorMaterial;
        peaksMaterial->setColor(m_peakColor);
        QSGFlatColorMaterial *rmsMaterial = new QSGFlatColorMaterial;
        rmsMaterial->setColor(m_rmsColor);

        peaksNode->setMaterial(peaksMaterial);
        peaksNode->setFlag(QSGNode::OwnsMaterial);

        rmsNode->setMaterial(rmsMaterial);
        rmsNode->setFlag(QSGNode::OwnsMaterial);

        if(m_samples.size() != 0)
        {
            createWaveformMesh(peaksGeometry,rmsGeometry,width,height);
        }

        peaksNode->setGeometry(peaksGeometry);
        rmsNode->setGeometry(rmsGeometry);
        rmsNode->setFlag(QSGNode::OwnsGeometry);
        peaksNode->setFlag(QSGNode::OwnsGeometry);

        parentNode->appendChildNode(peaksNode);
        parentNode->appendChildNode(rmsNode);
    }
    else
    {
        //Only recreate mesh geometry
        peaksNode = static_cast<QSGGeometryNode*>(parentNode->childAtIndex(0));
        rmsNode = static_cast<QSGGeometryNode*>(parentNode->childAtIndex(1));

        rmsGeometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), linesVertexCount);
        peaksGeometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), linesVertexCount);

        if(m_samples.size() != 0)
        {
            createWaveformMesh(peaksGeometry,rmsGeometry,width,height);
        }
        peaksNode->setGeometry(peaksGeometry);
        rmsNode->setGeometry(rmsGeometry);
    }

    m_geometryChanged = false;
    return parentNode;
}

/**
 * @brief WaveformPlot::openFile
 * @param url Unified resource locator of imported file (file://)
 */
void WaveformPlot::openFile(QString url)
{
    try
    {
        WaveformGenerator::openFile(QUrl(url).toLocalFile(),m_samples,m_duration);
        m_geometryChanged = true;
        if(m_exception)
        {
            m_exception = false;
            m_exceptionMessage.clear();
            emit exceptionChanged();
        }
    }
    catch(std::exception& e)
    {
        m_exception = true;
        m_exceptionMessage = QString(e.what());
        emit exceptionChanged();
    }

    emit samplesUpdated();
    emit durationUpdated();
    update();
}

void WaveformPlot::loadOpenedFile(AudioFile* file)
{
    try
    {
        WaveformGenerator::generateFrom(QUrl(file->fileUrl()).toLocalFile(),m_samples);
        m_duration = file->durationUs()/1000;
        m_geometryChanged = true;
        if(m_exception)
        {
            m_exception = false;
            m_exceptionMessage.clear();
            emit exceptionChanged();
        }
    }
    catch(std::exception& e)
    {
        m_exception = true;
        m_exceptionMessage = QString(e.what());
        emit exceptionChanged();
    }

    emit samplesUpdated();
    emit durationUpdated();
    update();
}
