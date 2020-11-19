import QtQuick 2.0
import QtQuick.Controls 2.0

Slider
{
    id: control
    width: parent.width
    height: 40

    readonly property int scale_s_min: 40
    readonly property int scale_s_max: 400
    readonly property int scale_step: 10
    property int scale_s: scale_s_min
    property int offset_ms: 0
    readonly property real width_ms: (timeline.width / timeline.scale_s)*1000

    readonly property int content_x: timeline.x
    readonly property int content_y: height
    readonly property int content_width: timeline.width

    readonly property int pos_ms: offset_ms + width_ms*value

    background: Canvas
    {
        id: timeline
        x: control.leftPadding + handle.width * 0.5
        y: control.topPadding + handle.height
        implicitHeight: control.height/2
        width: control.availableWidth - handle.width
        height: implicitHeight


        readonly property int scale_s: control.scale_s
        readonly property real offset_s: 1.0 - (control.offset_ms%1000)/1000.0

        onPaint:
        {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            ctx.strokeStyle = Qt.rgba(1, 0, 0, 0.4)
            ctx.lineWidth = 1

            ctx.beginPath()
            for(var x=0;x <= width;x += scale_s/10)
            {
                ctx.moveTo(x, 0)
                if(x % scale_s == ((offset_s == 1.0) ? 0 : (scale_s/10)*parseInt(offset_s*10, 10)))
                    ctx.lineTo(x, height * 0.6)
                else
                    ctx.lineTo(x, height * 0.3)
            }
            ctx.stroke();
        }
    }

    Row
    {
        id: text_row
        width: timeline.width
        x: timeline.x + ((timeline.offset_s == 1.0) ? 0 : (timeline.scale_s/10 * parseInt(timeline.offset_s*10, 10)))
        y: timeline.y + parent.height/2 * 0.6
        Repeater
        {
            model: (timeline.width / timeline.scale_s) + ((timeline.offset_s == 1.0) ? 1 : 0)
            Text
            {
                width: timeline.scale_s
                text: Math.ceil(control.offset_ms/1000) + index
                font.pointSize: 5
            }
        }
    }

    handle: Canvas {
        id: handle
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: 0
        implicitWidth: control.height/2
        implicitHeight: 10

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            ctx.strokeStyle = Qt.rgba(1, 0, 0, 0.4)
            ctx.fillStyle = "white"
            ctx.lineWidth = 1

            ctx.beginPath()
            ctx.moveTo(0, 0)
            ctx.lineTo(width, 0)
            ctx.lineTo(width, height - width * 0.5)
            ctx.lineTo(width * 0.5, height)
            ctx.lineTo(0, height - width * 0.5)
            ctx.lineTo(0, 0)

            ctx.fill()
            ctx.stroke()
        }
    }

    function redraw()
    {
        timeline.requestPaint();
    }
}


