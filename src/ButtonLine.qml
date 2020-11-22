import QtQuick 2.0
import QtQuick.Controls 2.0


Rectangle{
    id: control

    Button {
        id: button
        width: control.width*0.8
        height: control.height * 0.4
        x:0
        y: 0

        text: qsTr("Record")

    }



    Button
    {
          id: playback
          x: button.width + 50
          text: "play back"
          width: control.width * 0.6
          height: control.height * 0.4
          y: 0
    }

    Button
    {
          id: play
          x: button.width + playback.width + 50
          y: 0
          text: "play"
          width: control.width * 0.6
          height: control.height * 0.4
    }

    Button
    {
          id: playforward
          x: button.width + playback.width + play.width + 50
          y: 0
          text: "play forward"
          width: control.width * 0.6
          height: control.height * 0.4
    }

    Button
    {
          id: cut
          x: button.width + playback.width + play.width + playforward.width + 100
          y: 0
          text: "cut"
          width: control.width * 0.6
          height: control.height * 0.4
    }

    Button
    {
          id: del
          x: button.width + playback.width + play.width + playforward.width + cut.width + 100
          y: 0
          text: "del"
          width: control.width * 0.6
          height: control.height * 0.4
    }

    Button
    {
          id: notes
          x: button.width + playback.width + play.width + playforward.width + cut.width + del.width + 100
          y: 0
          text: "notes"
          width: control.width * 0.6
          height: control.height * 0.4
    }
}


