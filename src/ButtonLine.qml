import QtQuick 2.0
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.0
import QtQuick.Window 2.14
import QtQuick.Layouts 1.11

Rectangle{

    signal play()
    signal del()
    signal addNote(var noteText)
    function restoreLastNote()
    {
        text_for_notes.text = lastNoteText
    }

    id: control
    height: parent.height
    property string lastNoteText: ""

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
          onClicked: control.play()
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

    Dialog
    {
        id: notesDialog
        visible: false
        title: qsTr("Add note")
        ColumnLayout {
            width: parent ? parent.width : 100
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                TextArea {
                    id: text_for_notes
                    placeholderText: qsTr("Enter note text")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    onHoveredChanged: hovered ? (text_area.opacity = 1, text_area.border.color = "black") : (text_area.opacity = 0.6,  text_area.border.color= "gainsboro");
                    background: Rectangle {
                        id: text_area
                                implicitWidth: 100
                                implicitHeight: 40
                                color: "#9ad7c6"
                                opacity: 0.6
                                border.color: "gainsboro"
                                border.width: 1
                                radius: 5
                    }
                }
            }
        }

        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: {
            lastNoteText = text_for_notes.text
            text_for_notes.text = ""
            addNote(lastNoteText)
        }
        onRejected: {
            text_for_notes.text = lastNoteText = ""
        }

    }
    Button
    {
          id: notes
          x: button.width + jumpstart.width + play.width + jumpend.width + cut.width + del.width + (button.width)
          y: 0
          icon.width: del.width/3
          icon.color: "transparent"
          icon.source: "images/notes.jpg"
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
          onHoveredChanged:  hovered ? notes.opacity = 0.7 : notes.opacity = 1;
          onClicked: {
              notesDialog.visible = true;
          }
    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.25}
}
##^##*/
