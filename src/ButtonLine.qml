import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Window 2.14
import QtQuick.Layouts 1.11
//import itu.project.backend 1.0

Rectangle{

    signal play()
    signal del()
   //signal note_position()
    id: control
    height: parent.height
    property double value: 0
    property double note_y_pos: -270
    property variant items: ["", "", "", "", ""]
    property double note_index: 1



    Button {
        id: button
        width: control.width*0.7
        height: control.height * 0.4
        x:0
        y: 0
        background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    color: button.down ? "#d6d6d6" : "#BFE5D9"
                    border.color: "gainsboro"
                    border.width: 1
                    radius: 10
                }
        icon.color: "transparent"
        icon.source: "images/record.jpg"
        icon.width: button.width/3
        onHoveredChanged:  hovered ? button.opacity = 0.7 : button.opacity = 1;
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
          y: 0
          icon.color: "transparent"
          icon.source: "images/backward.jpg"
          icon.width: jumpstart.width/3
          width: control.width * 0.6
          height: control.height * 0.4
          background: Rectangle {
                      implicitWidth: 100
                      implicitHeight: 40
                      color: button.down ? "#d6d6d6" : "#BFE5D9"
                      border.color: "gainsboro"
                      border.width: 1
                      radius: 10
                  }
          onHoveredChanged:  hovered ? jumpstart.opacity = 0.7 : jumpstart.opacity = 1;
    }

    Button
    {
          id: play
          x: button.width + jumpstart.width + (button.width/2)
          onClicked: play()
          y: 0
          icon.color: "transparent"
          icon.source: "images/play.jpg"
          icon.width: play.width/3
          width: control.width * 0.6
          height: control.height * 0.4
          background: Rectangle {
                      implicitWidth: 100
                      implicitHeight: 40
                      color: button.down ? "#d6d6d6" : "#BFE5D9"
                      border.color: "gainsboro"
                      border.width: 1
                      radius: 10
                  }
          onHoveredChanged:  hovered ? play.opacity = 0.7 : play.opacity = 1;
    }

    Button
    {
          id: jumpend
          x: button.width + jumpstart.width + play.width + (button.width/2)
          y: 0
          icon.width: jumpend.width/3
          icon.color: "transparent"
          icon.source: "images/forward.jpg"
          width: control.width * 0.6
          height: control.height * 0.4
          background: Rectangle {
                      implicitWidth: 100
                      implicitHeight: 40
                      color: button.down ? "#d6d6d6" : "#BFE5D9"
                      border.color: "gainsboro"
                      border.width: 1
                      radius: 10
                  }
          onHoveredChanged:  hovered ? jumpend.opacity = 0.7 : jumpend.opacity = 1;
    }

    Button
    {
          id: cut
          x: button.width + jumpstart.width + play.width + jumpend.width + (button.width)
          y: 0
          icon.width: cut.width/3
          icon.color: "transparent"
          icon.source: "images/cut.jpg"
          width: control.width * 0.6
          height: control.height * 0.4
          background: Rectangle {
                      implicitWidth: 100
                      implicitHeight: 40
                      color: button.down ? "#d6d6d6" : "#BFE5D9"
                      border.color: "gainsboro"
                      border.width: 1
                      radius: 10
                  }
          onHoveredChanged:  hovered ? cut.opacity = 0.7 : cut.opacity = 1;
    }

    Button
    {
          id: del
          x: button.width + jumpstart.width + play.width + jumpend.width + cut.width + (button.width)
          onClicked: control.del()
          y: 0
          icon.width: del.width/3
          icon.color: "transparent"
          icon.source: "images/del.jpg"
          width: control.width * 0.6
          height: control.height * 0.4
          background: Rectangle {
                      implicitWidth: 100
                      implicitHeight: 40
                      color: button.down ? "#d6d6d6" : "#BFE5D9"
                      border.color: "gainsboro"
                      border.width: 1
                      radius: 10
                  }
          onHoveredChanged:  hovered ? del.opacity = 0.7 : del.opacity = 1;
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
        onEditingFinished:{text_for_notes.visible = false}

    }
    Button
    {
          id: notes
          x: button.width + jumpstart.width + play.width + jumpend.width + cut.width + del.width + (button.width)
          y: 0
          text: "notes"
          width: control.width * 0.6
          height: control.height * 0.4
          opacity: 1

          background: Rectangle {
                      implicitWidth: 100
                      implicitHeight: 40
                      color: button.down ? "#d6d6d6" : "#BFE5D9"
                      border.color: "gainsboro"
                      border.width: 1
                      radius: 10

                  }
          Text {
              id: note1
              color: "white";
              x: 0;
              y: -column.height/1.5;
              width: 20;
              height: 20;
              visible: true
              text: text_for_notes.text
          }
          Text {
              id: note2
              color: "white";
              x: 0;
              y: -(column.height/1.5 - 15) ;
              width: 20;
              height: 20;
              visible: true
              text: text_for_notes.text
          }
          Text {
              id: note3
              color: "white";
              x: 0
              y: -(column.height/1.5 - 30) ;
              width: 20;
              height: 20;
              visible: true
              text: text_for_notes.text
          }
          Text {
              id: note4
              color: "white";
              x: 0
              y: -(column.height/1.5 - 45) ;
              width: 20;
              height: 20;
              visible: true
              text: text_for_notes.text
          }
          Text {
              id: note5
              color: "white";
              x: 0
              y: -(column.height/1.5 - 60);
              width: 20;
              height: 20;
              visible: true
              text: text_for_notes.text
          }
          Text {
              id: note6
              color: "white";
              x: 0
              y: -(column.height/1.5 - 75);
              width: 20;
              height: 20;
              visible: true
              text: text_for_notes.text
          }
          Text {
              id: note7
              color: "white";
              x: 0
              y: -(column.height/1.5 - 90);
              width: 20;
              height: 20;
              visible: true
              text: text_for_notes.text
          }
          Text {
              id: note8
              color: "white";
              x: 0
              y: -(column.height/1.5 - 105);
              width: 20;
              height: 20;
              visible: true
              text: text_for_notes.text
          }
          onHoveredChanged:  hovered ? notes.opacity = 0.7 : notes.opacity = 1;
          onClicked: {
              //control.note_position();
              if(text_for_notes.visible == false)
              {
                  if (note_index == 0)
                  {
                      note1.text = text_for_notes.text
                      text_for_notes.visible = true
                      note1.visible = true
                      note2.visible = false
                      note3.visible = false
                      note4.visible = false
                      note5.visible = false
                      note6.visible = false
                      note7.visible = false
                      note8.visible = false
                  }
                  else if (note_index == 1)
                  {
                      note1.text = text_for_notes.text
                      text_for_notes.visible = true
                      note2.visible = true
                      note3.visible = false
                      note4.visible = false
                      note5.visible = false
                      note6.visible = false
                      note7.visible = false
                      note8.visible = false
                  }
                  else if (note_index == 2)
                  {
                      note3.text = text_for_notes.text
                      text_for_notes.visible = true
                      note3.visible = true
                  }
                  else if (note_index == 3)
                  {
                      note4.text = text_for_notes.text
                      text_for_notes.visible = true
                      note4.visible = true
                  }
                  else if (note_index == 4)
                  {
                      note5.text = text_for_notes.text
                      text_for_notes.visible = true
                      note5.visible = true
                  }
                  else if (note_index == 5)
                  {
                      note6.text = text_for_notes.text
                      text_for_notes.visible = true
                      note6.visible = true
                  }
                  else if (note_index == 6)
                  {
                      note7.text = text_for_notes.text
                      text_for_notes.visible = true
                      note7.visible = true
                  }
                  else if (note_index == 7)
                  {
                      note8.text = text_for_notes.text
                      text_for_notes.visible = true
                      note8.visible = true
                  }
                  note_index++
              }
              else
              {
                  text_for_notes.visible = false
              }
          }
    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.25}
}
##^##*/
