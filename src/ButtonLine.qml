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
          id: jumpstart
          x: button.width + 50
          text: "jump start"
          width: control.width * 0.6
          height: control.height * 0.4
          y: 0
    }

    Button
    {
          id: play
          x: button.width + jumpstart.width + 50
          y: 0
          text: "play"
          width: control.width * 0.6
          height: control.height * 0.4
    }

    Button
    {
          id: jumpend
          x: button.width + jumpstart.width + play.width + 50
          y: 0
          text: "jump end"
          width: control.width * 0.6
          height: control.height * 0.4
    }

    Button
    {
          id: cut
          x: button.width + jumpstart.width + play.width + jumpend.width + 100
          y: 0
          text: "cut"
          width: control.width * 0.6
          height: control.height * 0.4
    }

    Button
    {
          id: del
          x: button.width + jumpstart.width + play.width + jumpend.width + cut.width + 100
          y: 0
          text: "del"
          width: control.width * 0.6
          height: control.height * 0.4
    }

    Button
    {
          id: notes
          x: button.width + jumpstart.width + play.width + jumpend.width + cut.width + del.width + 100
          y: 0
          text: "notes"
          width: control.width * 0.6
          height: control.height * 0.4
    }
}


