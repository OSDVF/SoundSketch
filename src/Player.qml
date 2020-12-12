import QtQuick 2.0
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.0
import itu.project.backend 1.0

Rectangle
{
    id: control
    width: parent.width
    height: parent.height
    radius: 5
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

    function addNoteAtHandlePos(text)
    {
        var index = clipList.getIndexOfItemAtPos(pos_ms);
        if(index === -1)
        {
            nothingSelectedDialog.visible = true
            return false;
        }

        var child = clipsFlickable.children[index];
        child.children[0].addNote(pos_ms - clipList.get(index).posMs, text);
        return true;
    }


    function deleteSelectedClip()
    {
        if(clipList.count > 0)
            clipList.remove(selectedClipIndex);
    }

    function deleteAllClips()
    {
        clipList.clear()
    }

    function getSelectedClipUrl()
    {
           return clipList.get(selectedClipIndex).audioFile.fileUrl;
    }

    //Models
    ClipListModel {
        id: clipList
    }
    ClipListModel {
        id: repositionPreview
    }
    property bool dragOngoing: false
    property bool repositionSuccess: false

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
                id: clipsMouseArea
                function endReposition(mouse)
                {
                    if(dragOngoing)
                    {
                        dragOngoing = false
                        console.log("Ended")
                        if(repositionSuccess)
                        {
                            console.log("Success")
                            repositionPreview.copyTo(clipList)//Update list with preview result
                        }
                        listDisplay.model = clipList
                        repositionPreview.clear()
                    }
                }

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
                onReleased: endReposition(mouse)

                Flickable
                {
                    id: clipsFlickable
                    anchors.fill: parent
                    contentWidth: timeline.content_width
                    interactive: false
                    contentX: timeline.offset_pixels
                    clip: true

                    Repeater //Reads the list of clips and displays them in the timeline
                    {
                        id: listDisplay
                        model: clipList
                        AudioClip {
                            audioFile: model.clipItemModel.audioFile
                            x: model.clipItemModel.posMs * timeline.scale_ms
                            scaleMs: timeline.scale_ms
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            peaceTimeWidth: durationMs * timeline.scale_ms
                            debugText: index.toString()
                            backColor: {
                                var c = Style.backColors[Math.max(index,0) % Style.backColors.length];
                                if(selectedClipIndex === index)
                                {
                                    return Qt.lighter(c,1.1);
                                }
                                return c;
                            }

                            waveColor: Style.waveColors[Math.max(index,0) % Style.waveColors.length]
                            formatInfoTextColor: Style.formatInfoTextColor
                            onClicked:
                            {
                                selectedClipIndex = index;
                                endReposition();
                            }
                            onAlternativePress: {
                                dragOngoing = true
                                selectedClipIndex = index;
                                console.log("Drag Started")
                                clipList.copyTo(repositionPreview);
                                listDisplay.model = repositionPreview
                            }

                            onMousePosChanged: {
                                if(dragOngoing)
                                {
                                    repositionSuccess = clipList.reposition(index,mouse.x,repositionPreview) !== -1
                                }
                            }
                            onReleased: clipsMouseArea.endReposition(mouse)
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
        to: Math.max(50000 - timeline.width_ms,totalDurationMs - timeline.width_ms)
        value: from
        onValueChanged:
        {
            timeline.offset_ms = parseInt(value, 10);
            timeline.redraw();
        }
    }

    MessageDialog
    {
        id: nothingSelectedDialog
        visible: false
        title: qsTr("Select something")
        text: qsTr("There is no audio clip at playhead position")
        standardButtons: StandardButton.Close
        icon: StandardIcon.Warning
        modality: Qt.ApplicationModal
    }
}
