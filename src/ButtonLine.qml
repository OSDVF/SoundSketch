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
        width: control.width*0.6
        height: control.height * 0.3
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
        icon.width: button.width
        icon.height: icon.width
        onClicked: audiorecorder.visible = true
        Audiorecorder{
            id: audiorecorder
            opacity: 1
            x: (mainWindow.width - audiorecorder.width)/8
            y: -mainWindow.height + player.height/2
            visible: false;
        }

    }



    Button
    {
          id: jumpstart
          x: mainWindow.width / 2 - (jumpstart.width*1.75)
          y: 0
          icon.color: "transparent"
          icon.source: "images/backward.jpg"
          icon.width: jumpstart.width
          icon.height: icon.width
          width: control.width
          height: control.height * 0.3
          background: Rectangle {
                      implicitWidth: 100
                      implicitHeight: 40
                      color: jumpstart.down ? "#d6d6d6" : "#BFE5D9"
                      border.color: "gainsboro"
                      border.width: 1
                      radius: 10
                  }
          onHoveredChanged:  hovered ? jumpstart.opacity = 0.7 : jumpstart.opacity = 1;
    }

    Button
    {
          id: play
          x: jumpstart.x + jumpstart.width
          onClicked: control.play()
          y: 0
          icon.color: "transparent"
          icon.source: "images/play.jpg"
          icon.width: play.width
          icon.height: icon.width
          width: control.width
          height: control.height * 0.3
          background: Rectangle {
                      implicitWidth: 100
                      implicitHeight: 40
                      color: play.down ? "#d6d6d6" : "#BFE5D9"
                      border.color: "gainsboro"
                      border.width: 1
                      radius: 10
                  }
          onHoveredChanged:  hovered ? play.opacity = 0.7 : play.opacity = 1;
    }

    Button
    {
          id: jumpend
          x: play.x + play.width
          y: 0
          icon.width: jumpend.width
          icon.height: icon.width
          icon.color: "transparent"
          icon.source: "images/forward.jpg"
          width: control.width
          height: control.height * 0.3
          background: Rectangle {
                      implicitWidth: 100
                      implicitHeight: 40
                      color: jumpend.down ? "#d6d6d6" : "#BFE5D9"
                      border.color: "gainsboro"
                      border.width: 1
                      radius: 10
                  }
          onHoveredChanged:  hovered ? jumpend.opacity = 0.7 : jumpend.opacity = 1;
    }

    Button
    {
          id: cut
          x: mainWindow.width - del.width - cut.width*1
          y: - mainWindow.height + buttonline.height - cut.height*1.5
          //y: - 300
          icon.width: cut.width
          icon.height: icon.width
          icon.color: "transparent"
          icon.source: "images/cut.jpg"
          width: control.width * 0.6
          height: control.height * 0.3
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
          x: mainWindow.width - del.width - cut.width*2.2
          onClicked: control.del()
          y: - mainWindow.height + buttonline.height - del.height*1.5
          icon.width: del.width
          icon.height: icon.width
          icon.color: "transparent"
          icon.source: "images/del.jpg"
          width: control.width * 0.6
          height: control.height * 0.3
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
          x: mainWindow.width - notes.width*2
          y: 0
          icon.width: notes.width
          icon.height: icon.width
          icon.color: "transparent"
          icon.source: "images/notes.jpg"
          width: control.width * 0.6
          height: control.height * 0.3
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
