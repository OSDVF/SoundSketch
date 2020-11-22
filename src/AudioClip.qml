import QtQuick 2.0
import itu.project.frontend 1.0

Rectangle
{
    property color backColor: "#E9E9E9"
    property color waveColor: "#AAAAAA"
    readonly property real durationMs: plot.durationMs
    function loadAudioFile(audioFile)
    {
        plot.loadOpenedFile(audioFile)
    }

    border.color: Qt.lighter(backColor)
    border.width: 2
    radius: 10

    color: backColor
    WaveformPlot
    {
        id:plot
        anchors.fill: parent
        rmsColor: Qt.darker(waveColor)
        peakColor: waveColor
        Text
        {
            color: "steelblue"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            enabled: false
            anchors.horizontalCenter: parent.horizontalCenter
            text: parent.exception
            visible: parent.hasException
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
