import QtQuick 2.0
import QtQuick.Layouts 1.15
import itu.project.frontend 1.0

Rectangle {
    id: mainRect
    property color backColor: "#E9E9E9"
    //width of the clip when there is no error
    property real peaceTimeWidth: implicitWidth
    width: {
        if(plot.hasException)
            return errorText.paintedWidth + 20;
        else return peaceTimeWidth;
    }

    property color waveColor: "#AAAAAA"
    property color formatInfoTextColor: "white"
    readonly property real durationMs: plot.durationMs
    property var audioFile
    function loadAudioFile(audioFileToLoad) {
        audioFile = audioFileToLoad
        plot.loadOpenedFile(audioFileToLoad)
    }
    signal clicked(var mouse)

    border.color: Qt.lighter(backColor,1.2)
    border.width: 2
    radius: 10

    color: backColor
    WaveformPlot {
        id: plot
        anchors.fill: parent
        rmsColor: Qt.darker(waveColor)
        peakColor: waveColor
        Rectangle {
            color: "#5c000000"
            radius: 5
            border.width: 0
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 5
            anchors.topMargin: 5
            width: childrenRect.width + 10
            height: childrenRect.height + 10
            RowLayout {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 5
                anchors.topMargin: 5
                spacing: 10
                Text {
                    text: audioFile.baseName
                    color: "white"
                }
                Text {
                    id: formatLabel
                    color: formatInfoTextColor
                    text: audioFile.format
                }
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: mainRect.clicked(mouse)
        }
    }
    Text {
        id: errorText
        color: "steelblue"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        text: plot.exception
        anchors.fill: parent
        anchors.margins: 10
        visible: plot.hasException
    }
}


