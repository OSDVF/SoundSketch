import QtQuick 2.0
import QtQuick.Controls 2.0
import itu.project.backend 1.0
import "ClipPositioning.js" as ClipPositioning

Rectangle
{
    id: control
    width: parent.width
    height: parent.height

    readonly property int pos_ms: timeline.pos_ms
    property real maxTime: 50000

    //Aliases for project object model manipulation
    property alias clipList: clipList
    signal dropped(QtObject drop)

    function addClip(fileUrl, pixelOffset) {
        //Set new clip properties
        var file = audioFile.createObject(parent,{fileUrl:fileUrl})
        clipList.append({
                            "file": file,
                            "posMs": pixelOffset / timeline.scale_ms + timeline.offset_ms,
                            "durationMs": file.durationUs / 1000
                        })
    }
    Component{
        id:audioFile
        AudioFile{

        }
    }

    //Models
    ListModel {
        id: clipList
    }

    Rectangle
    {
        id: stopy

        x: timeline.content_x
        y: timeline.content_y
        width: timeline.content_width + 1
        height: time_offset_slider.y - y

        //border.width: 1 //debug
        color: Style.timelineColor

        DropArea //For inserting audio files
        {
            anchors.fill: parent
            id: dropArea
            onDropped: control.dropped(drop)

            MouseArea
            {
                anchors.fill: parent
                onWheel:
                {
                    var sc = timeline.scale_s + (wheel.angleDelta.y / 12)
                    if (sc > timeline.scale_s_min
                            && sc <= timeline.scale_s_max)
                            {
                        timeline.scale_s = sc
                        timeline.redraw()
                    }
                }
                onPositionChanged:
                {
                    if(pressed)
                    {
                        timeline.value = mouseX / width;
                    }
                }

                Flickable
                {
                    anchors.fill: parent
                    contentWidth: timeline.content_width
                    interactive: false
                    contentX: timeline.offset_pixels
                    clip: true

                    Repeater //Reads the list of clips and displays them in the timeline
                    {
                        model: clipList
                        AudioClip {
                            x: model.posMs * timeline.scale_ms
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: durationMs * timeline.scale_ms
                            backColor: Style.backColors[index % Style.backColors.length]
                            waveColor: Style.waveColors[index % Style.waveColors.length]
                        }
                        onItemAdded: {
                            item.loadAudioFile(model.get(index).file)
                            ClipPositioning.recalculatePositions();
                        }
                    }
                }
            }
        }
    }

    Timeline
    {
        id: timeline
    }

    Rectangle
    {
        x: timeline.content_x + timeline.content_width * timeline.value
        y: 0
        width: 1
        height: timeline.height + stopy.height
        color: "black"
    }

    Slider
    {
        id: time_offset_slider
        width: parent.width
        y: parent.height - height
        from: 0
        to: maxTime - timeline.width_ms
        value: from
        onValueChanged:
        {
            timeline.offset_ms = parseInt(value, 10);
            timeline.redraw();
        }
    }
}
