import QtQuick 2.0
import QtQuick.Layouts 1.15
import itu.project.frontend 1.0
import QtQml.Models 2.15

Rectangle {
    id: mainRect
    property bool selected: false
    property color backColor: "#E9E9E9"
    //width of the clip when there is no error
    property real peaceTimeWidth: implicitWidth
    property real scaleMs: 0.04
    width: {
        if (plot.hasException)
            return errorText.paintedWidth + 20
        else
            return peaceTimeWidth
    }

    property color waveColor: "#AAAAAA"
    property color formatInfoTextColor: "white"
    property string debugText: ""
    readonly property real durationMs: plot.audioFile.durationMs
    property var audioFile

    property color textBackColor: "#5c000000"
    property real textRectRadius: 5

    border.color: Qt.lighter(backColor, 1.2)
    border.width: 2
    radius: 10

    color: {
        if(selected)
        {
            return Qt.lighter(backColor, 1.1);
        }
        return backColor;
    }

    function addNote(pos, text) {
        notesModel.append({
                              "notePos": pos,
                              "noteText": text
                          })
    }

    ListModel {
        id: notesModel
    }
    WaveformPlot {
        id: plot
        anchors.fill: parent
        rmsColor: Qt.darker(waveColor)
        peakColor: waveColor
        audioFile: mainRect.audioFile
        Rectangle {
            color: textBackColor
            radius: textRectRadius
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
                Text {
                    text: debugText
                }
            }
        }
    }

    Flickable {
        anchors.fill: parent
        anchors.bottomMargin: 5
        anchors.topMargin: 5
        interactive: false
        Repeater {
            model: notesModel

            Rectangle {
                x: notePos * scaleMs
                y: index * (font.pixelSize + 10)
                radius: textRectRadius
                width: childrenRect.width + 10
                height: childrenRect.height + 10
                color: "#75e7e5ca"
                Text {
                    x: 5
                    y: 5
                    text: noteText
                }
            }
        }
    }

    Text {
        id: errorText
        color: "steelblue"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        text: plot.audioFile.exception
        anchors.fill: parent
        anchors.margins: 10
        visible: plot.audioFile.hasException
    }
}
