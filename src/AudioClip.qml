import QtQuick 2.0
import QtQuick.Layouts 1.15
import itu.project.frontend 1.0
import QtQml.Models 2.15
import QtQuick.Controls 2.15

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
                    text: {
                        var sec = audioFile.durationMs/1000
                        var mins = Math.floor(sec/60)
                        return mins + ":" + sec
                    }
                }
                Text {
                    text: debugText
                    visible:false
                }
            }
        }
    }

    Image {
        id: leftHandle
        opacity: positioning ? 0.682 : 0.3
        x: 5
        anchors.top: parent.top
        source: "images/handle.png"
        anchors.topMargin: 34
        sourceSize.width: 35
        visible: selected
        property bool positioning: false

        MouseArea {
            anchors.fill: parent
            onPressed: {
                leftHandle.positioning = true
            }
            onMouseXChanged:
            {
                if(leftHandle.positioning)
                {
                    resizeOverlay.x = 0
                    resizeOverlay.width = mouse.x
                    resizeOverlay.visible = true
                }
            }
            onReleased: {
                leftHandle.positioning = false
                resizeOverlay.visible = false

                audioFile.startMs = Math.max(audioFile.startMs + resizeOverlay.width / scaleMs, 0)
            }
        }
    }

    Image {
        id: rightHandle
        opacity: positioning ? 0.682 : 0.3
        anchors.right: parent.right
        anchors.top: parent.top
        source: "images/handle.png"
        anchors.topMargin: 34
        anchors.rightMargin: -30
        sourceSize.width: 35

        transform: Scale{ xScale: -1 }
        visible: selected
        property bool positioning: false

        MouseArea {
            anchors.fill: parent
            onPressed: {
                rightHandle.positioning = true
            }
            onMouseXChanged:
            {
                if(rightHandle.positioning)
                {
                    resizeOverlay.x = mainRect.width - mouse.x
                    resizeOverlay.width = mainRect.width - resizeOverlay.x
                    resizeOverlay.visible = true
                }
            }
            onReleased: {
                rightHandle.positioning = false
                resizeOverlay.visible = false

                audioFile.endMs = Math.min(audioFile.endMs - resizeOverlay.width / scaleMs, audioFile.durationMs)
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
                id: notebox
                x: notePos * scaleMs
                y: (index+1) * (font.pixelSize + 15)
                radius: textRectRadius
                width: notetextarea.width + 10
                height: notetextarea.height + 10
                color: "#75e7e5ca"
                property bool clicknum: true
                Text {
                    id: notetextarea
                    x: 5
                    y: 5
                    text: noteText
                }
                MouseArea{
                    id: notearea
                    anchors.fill: notebox
                    onClicked: {
                        if (clicknum)
                        {
                            deleteButton.visible = true;
                            notebox.color = "salmon";
                            clicknum = false
                        }
                        else
                        {
                            deleteButton.visible = false;
                            notebox.color = "#75e7e5ca";
                            clicknum = true
                        }
                    }
                }
                Button{
                    id: deleteButton
                    x: notetextarea.x + notebox.width
                    y: notetextarea.y - 5
                    width: 20
                    height: notebox.height
                    visible: false
                    background: Rectangle{color: "salmon"; radius: notebox.radius}
                    text:  "X"
                    onClicked: {notebox.width = 0; notebox.height = 0; notetextarea.text = "";}
                }
            }

        }
    }

    Rectangle {
        id: resizeOverlay
        opacity: 0.5
        visible: false
        anchors.top: parent.top
        anchors.bottom: parent.bottom
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
