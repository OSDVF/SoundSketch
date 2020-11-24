import QtQuick 2.0
import QtQuick.Controls 2.0
import itu.project.backend 1.0

Rectangle
{
    id: control
    width: parent.width
    height: parent.height

    readonly property int pos_ms: timeline.pos_ms
    property int selectedClipIndex: 0
    property alias totalDurationMs: clipList.totalDurationMs

    //Aliases for project object model manipulation
    property alias clipList: clipList
    signal dropped(QtObject drop)

    function addClip(fileUrl, pixelOffset) {
        //Set new clip properties
        clipList.append(pixelOffset / timeline.scale_ms + timeline.offset_ms, fileUrl)
    }
    function deleteSelectedClip()
    {
        clipList.remove(selectedClipIndex);
    }

    //Models
    ClipListModel {
        id: clipList
    }

    Rectangle
    {
        id: stopy

        x: timeline.content_x
        y: timeline.content_y
        width: timeline.content_width + 1
        height: time_offset_slider.y - y

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
                            x: model.clipItemModel.posMs * timeline.scale_ms
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: durationMs * timeline.scale_ms
                            backColor: {
                                var c = Style.backColors[index % Style.backColors.length];
                                if(selectedClipIndex === index)
                                {
                                    return Qt.lighter(c,1.1);
                                }
                                return c;
                            }

                            waveColor: Style.waveColors[index % Style.waveColors.length]
                            formatInfoTextColor: Style.formatInfoTextColor
                            onClicked:
                            {
                                selectedClipIndex = index;
                            }
                        }
                        onItemAdded: {
                            item.loadAudioFile(model.get(index).audioFile)
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
        to: Math.max(50000,totalDurationMs - timeline.width_ms)
        value: from
        onValueChanged:
        {
            timeline.offset_ms = parseInt(value, 10);
            timeline.redraw();
        }
    }
}
