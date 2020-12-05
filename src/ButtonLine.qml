import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Window 2.14
import QtQuick.Layouts 1.11
//import itu.project.backend 1.0

Rectangle{
    function add_note(offset)
    {
        var newObject = Qt.createQmlObject('import QtQuick 2.0; Text {color: "cornflowerblue"; x: 0  ; y: note_y_pos ; width: 20; height: 20; text: text_for_notes.text }', notes,
                                             "dynamicSnippet1");
        items[note_index] = newObject
        items[note_index].text = text_for_notes.text
        for (var x = 0; x < note_index; x++){
            items[x].y = x*10+2;
        }
        note_index += 1
    }
    id: control
    height: parent.height
    property double value: 0
    property double note_y_pos: -270
    property variant items: ["", "", "", "", ""]
    property double note_index: 0


    Button {
        id: button
        width: control.width*0.7
        height: control.height * 0.4
        x:0
        y: 0

        text: qsTr("Record")
        onClicked: audiorecorder.visible = true
        Audiorecorder{
            id: audiorecorder
            x: column.width/4
            y:-365
            width: column.width/2
            height: 300
            visible: false;
        }

    }



    Button
    {
          id: jumpstart
          x: button.width + (button.width/2)
          text: "jump start"
          width: control.width * 0.6
          height: control.height * 0.4
          y: 0
    }

    Button
    {
          id: play
          x: button.width + jumpstart.width + (button.width/2)
          y: 0
          text: "play"
          width: control.width * 0.6
          height: control.height * 0.4

    }

    Button
    {
          id: jumpend
          x: button.width + jumpstart.width + play.width + (button.width/2)
          y: 0
          text: "jump end"
          width: control.width * 0.6
          height: control.height * 0.4
    }

    Button
    {
          id: cut
          x: button.width + jumpstart.width + play.width + jumpend.width + (button.width)
          y: 0
          text: "cut"
          width: control.width * 0.6
          height: control.height * 0.4
    }

    Button
    {
          id: del
          x: button.width + jumpstart.width + play.width + jumpend.width + cut.width + (button.width)
          y: 0
          text: "del"
          width: control.width * 0.6
          height: control.height * 0.4
    }
    TextField {
        id: text_for_notes
        x:0
        y:-176
        anchors.horizontalCenter: parent.horizontalCenter
        width: 475
        height: 119
        placeholderText: qsTr("Enter notes")
        visible: false
        anchors.horizontalCenterOffset: 432
    }
    Button
    {
          id: notes
          x: button.width + jumpstart.width + play.width + jumpend.width + cut.width + del.width + (button.width)
          y: 0
          text: "notes"
          width: control.width * 0.6
          height: control.height * 0.4
          signal note_position( var offset)

          onClicked: {
              if(text_for_notes.visible == false)
              {
                text_for_notes.visible = true
                add_note(5);
              }
              else
              {
                  text_for_notes.visible = false
                  for (var i = 0; i < note_index; i++)
                      items[i].visible = true;
              }
          }
    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.25}
}
##^##*/
