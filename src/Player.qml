import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle
{
    id: control
    width: parent.width
    height: parent.height

    readonly property int pos_ms: timeline.pos_ms

    Rectangle
    {
        id: stopy

        x: timeline.content_x
        y: timeline.content_y
        width: timeline.content_width + 1
        height: time_offset_slider.y - y

        //border.width: 1 //debug
        color: "#CCCCCC"

        MouseArea
        {
            anchors.fill: parent;
            onWheel:
            {
                var sc = timeline.scale_s + (wheel.angleDelta.y / 12)
                if (sc > timeline.scale_s_min && sc <= timeline.scale_s_max)
                {
                    timeline.scale_s = sc;
                    timeline.redraw();
                }
            }
            onPositionChanged:
            {
                if(pressed)
                {
                    timeline.value = mouseX / width;
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
        to: 50000 - timeline.width_ms
        value: from
        onValueChanged:
        {
            timeline.offset_ms = parseInt(value, 10);
            timeline.redraw();
        }
    }
}
