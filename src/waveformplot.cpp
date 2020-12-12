#include "waveformplot.h"
#include <QSGGeometry>
#include <QSGFlatColorMaterial>
#include <QSGGeometryNode>
#include <QSGSimpleRectNode>
#include <QUrl>
#include "AudioFileWithWaveformMesh.h"
#include <algorithm> //for std::min

WaveformPlot::WaveformPlot(QQuickItem *parent):QQuickItem(parent), m_geometryChanged(false)
{
    setFlag(ItemHasContents, true);
}

AudioFile *WaveformPlot::audioFile()
{
    return m_audioFile;
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
    auto& samples = m_audioFile->waveformBuffer;
    auto data = samples.constData();
    float zeroY = height/2;
    auto samplesCount = samples.size();
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
            auto singleSample = data[s];
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
    AudioFileWithWaveformMesh * audioMeshFile = dynamic_cast<AudioFileWithWaveformMesh *>(m_audioFile);
    if (rect.isEmpty()) {
        delete parentNode;
        if(audioMeshFile != nullptr)
            audioMeshFile->waveformMeshNode = nullptr;
        return nullptr;
    }
    if(m_updateMeshWithPool && audioMeshFile != nullptr && audioMeshFile->waveformMeshNode != nullptr)
    {
        if(audioMeshFile->waveformMeshNode != parentNode)//audioFile->this copy direction
        {
            if(parentNode != nullptr)
                delete parentNode;
            m_geometryChanged = false;
            m_updateMeshWithPool = false;
            return audioMeshFile->waveformMeshNode;
        }
        m_updateMeshWithPool = false;
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
        if(audioMeshFile != nullptr)
            audioMeshFile->waveformMeshNode = parentNode;

        //Create nodes, materials, geometry and background rectangle
        peaksNode = new QSGGeometryNode;
        rmsNode = new QSGGeometryNode;
        rmsGeometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), ceil(linesVertexCount));
        peaksGeometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), ceil(linesVertexCount));

        QSGFlatColorMaterial *peaksMaterial = new QSGFlatColorMaterial;
        peaksMaterial->setColor(m_peakColor);
        QSGFlatColorMaterial *rmsMaterial = new QSGFlatColorMaterial;
        rmsMaterial->setColor(m_rmsColor);

        peaksNode->setMaterial(peaksMaterial);
        peaksNode->setFlag(QSGNode::OwnsMaterial);

        rmsNode->setMaterial(rmsMaterial);
        rmsNode->setFlag(QSGNode::OwnsMaterial);

        if(m_audioFile->waveformBuffer.size() != 0)
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

        static_cast<QSGFlatColorMaterial*>(peaksNode->material())->setColor(m_peakColor);
        static_cast<QSGFlatColorMaterial*>(rmsNode->material())->setColor(m_rmsColor);
        rmsNode->markDirty(QSGNode::DirtyMaterial);
        peaksNode->markDirty(QSGNode::DirtyMaterial);

        rmsGeometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), ceil(linesVertexCount));
        peaksGeometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), ceil(linesVertexCount));

        if(m_audioFile->waveformBuffer.size() != 0)
        {
            createWaveformMesh(peaksGeometry,rmsGeometry,width,height);
        }
        peaksNode->setGeometry(peaksGeometry);
        rmsNode->setGeometry(rmsGeometry);
    }

    if(m_updateMeshWithPool)//this->audioFile direction
    {
        if(parentNode != nullptr)
        {
            m_updateMeshWithPool = false;
            audioMeshFile->waveformMeshNode = parentNode;
        }
    }

    m_geometryChanged = false;
    return parentNode;
}

/**
 * @brief WaveformPlot::openFile
 * @param url Unified resource locator of imported file (file://)
 */
void WaveformPlot::openFileAndGenerate(QString url)
{
    if(m_audioFile != nullptr)
        delete m_audioFile;
    m_audioFile = new AudioFileWithWaveformMesh();
    m_audioFile->openFileUrl(url);

    emit audioFileChanged();
    update();
}

void WaveformPlot::connectToFile(AudioFile* file)
{
    if(file == m_audioFile)
        return;

    if((m_audioFile = dynamic_cast<AudioFileWithWaveformMesh *>(file) )!= nullptr)
    {
        m_updateMeshWithPool = true;
    }
    else
    {
        m_audioFile = file;
    }
    m_geometryChanged = true;

    if(m_audioFile->waveformBuffer.size() == 0)
    {
        m_audioFile->loadWaveform();
    }

    emit audioFileChanged();
    update();
}
