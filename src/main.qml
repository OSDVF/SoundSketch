import QtQuick 2.14
import QtQuick.Window 2.14
import QtQml.Models 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4
import itu.project.backend 1.0

ApplicationWindow
{
    id: mainWindow
    width: 400
    height: 700
    visible: true
    title: qsTr("Hello World")

    property string copiedUrl: ""

    FileDialog {
        id: saveDialog
        title: "Save Dialog"
        selectMultiple : false
        selectExisting: false
    }
    Dialog {
        id: dialog
        x: mainWindow.width / 2 - dialog.width/2
        y: mainWindow.height / 2 - dialog.height/2
        title: "Title"
        standardButtons: Dialog.Ok
        visible: false
        Image {
            id: name
            y: 0
            source: "images/newproject.png"
            width: 200
            height: 200
            Text {
                y: name.height - 25
                x: 25
                text: qsTr("You successfully created \n       a new project!")
            }
        }

        onAccepted: console.log("Ok clicked")
    }

    Drawer{
        id: menu
        width: mainWindow.width * 0.3
        height: mainWindow.height
        Rectangle{
            id: mainmenu
            width: menu.width
            height: menu.height
            Button{
                id: project
                y: 0
                width: menu.width
                height: 70
                text: "Project"
                font.family: "Tahoma"
                font.pointSize: 10
                onClicked: projectmenu.visible = true
                background: Rectangle {
                    color: "#BFE5D9"
                    border.color: "gainsboro"
                    radius: 7
                }
            }
            Button{
                id: edit
                width: menu.width
                height: 70
                y: project.height
                text: "Edit"
                font.family: "Tahoma"
                font.pointSize: 10
                onClicked: editmenu.visible = true
                background: Rectangle {
                    color: "#BFE5D9"
                    border.color: "gainsboro"
                    radius: 7
                }
            }
            Button{
                id: help
                width: menu.width
                height: 70
                y: project.height + edit.height
                text: "Help"
                font.family: "Tahoma"
                font.pointSize: 10
                onClicked: helpmenu.visible = true
                background: Rectangle {
                    color: "#BFE5D9"
                    border.color: "gainsboro"
                    radius: 7
                }
            }
        }
        Rectangle{
            id: projectmenu
            width: menu.width
            height: menu.height
            visible: false
            Button{
                id: newproject
                y: 0
                width: menu.width
                height: 70
                text: "New project"
                font.family: "Tahoma"
                font.pointSize: 10
                background: Rectangle {
                    color: "#BFE5D9"
                    border.color: "gainsboro"
                    radius: 7
                }
                onClicked: player.deleteAllClips()
            }
            Button{
                id: openproject
                y: newproject.height
                width: menu.width
                height: 70
                text: "Open"
                font.family: "Tahoma"
                font.pointSize: 10
                onClicked: importDialog.open()
                background: Rectangle {
                    color: "#BFE5D9"
                    border.color: "gainsboro"
                    radius: 7
                }
            }
            Button{
                id: saveproject
                y: newproject.height + openproject.height
                width: menu.width
                height: 70
                text: "Save"
                font.family: "Tahoma"
                font.pointSize: 10
                onClicked: dialog.visible = true
                background: Rectangle {
                    color: "#BFE5D9"
                    border.color: "gainsboro"
                    radius: 7
                }
            }
            Button{
                id: quit
                y: newproject.height + openproject.height + saveproject.height
                width: menu.width
                height: 70
                text: "Quit"
                font.family: "Tahoma"
                font.pointSize: 10
                onClicked: Qt.quit()
                background: Rectangle {
                    color: "#BFE5D9"
                    border.color: "gainsboro"
                    radius: 7
                }
            }
        }
        Rectangle{
            id: editmenu
            width: menu.width
            height: menu.height
            visible: false
            Button{
                id: importaudio
                y: 0
                width: menu.width
                height: 70
                text: "Import audio"
                font.family: "Tahoma"
                font.pointSize: 10
                onClicked: importDialog.open()
                background: Rectangle {
                    color: "#BFE5D9"
                    border.color: "gainsboro"
                    radius: 7
                }
            }
            Button{
                id: cut
                y: importaudio.height
                width: menu.width
                height: 70
                text: "Cut"
                font.family: "Tahoma"
                font.pointSize: 10
                onClicked: {
                    copiedUrl = player.getSelectedClipUrl();
                    player.deleteSelectedClip();
                }

                background: Rectangle {
                    color: "#BFE5D9"
                    border.color: "gainsboro"
                    radius: 7
                }
            }
            Button{
                id: copy
                y: importaudio.height + cut.height
                width: menu.width
                height: 70
                text: "Copy"
                font.family: "Tahoma"
                font.pointSize: 10
                onClicked: {
                    copiedUrl = player.getSelectedClipUrl();
                }
                background: Rectangle {
                    color: "#BFE5D9"
                    border.color: "gainsboro"
                    radius: 7
                }
            }
            Button{
                id: paste
                y: importaudio.height + cut.height + copy.height
                width: menu.width
                height: 70
                text: "Paste"
                font.family: "Tahoma"
                font.pointSize: 10
                onClicked: {
                    importAudio(copiedUrl, 0);
                }
                background: Rectangle {
                    color: "#BFE5D9"
                    border.color: "gainsboro"
                    radius: 7
                }
            }
        }
        Rectangle{
            id: helpmenu
            width: menu.width
            height: menu.height
            visible: false
            Button{
                id: about
                width: menu.width
                height: 70
                text: "About"
                font.family: "Tahoma"
                font.pointSize: 10
                onClicked: {about_text.visible = true; menu.visible = false}
                background: Rectangle {
                    color: "#BFE5D9"
                    border.color: "gainsboro"
                    radius: 7
                }
            }
        }

        Button{
            y: menu.height - 50
            x: menu.width - 50
            width: 50
            height: 50
            icon.source: "images/return.jpg"
            onClicked: {
                helpmenu.visible = false;
                editmenu.visible = false;
                projectmenu.visible = false;
            }
            background: Rectangle {
                color: "#BFE5D9"
                border.color: "gainsboro"
                radius: 7
            }
        }
    }

    function basename(fileName)
    {
        return (fileName.slice(fileName.lastIndexOf("/") + 1))
    }
    function extension(fileName)
    {
        return (fileName.slice(fileName.lastIndexOf(".") + 1))
    }
    readonly property var supportedExtensions: ["mp3", "wav", "aac", "m4a"]
    function importAudio(fileName,pixelPosition)
    {
        if (supportedExtensions.indexOf(extension(fileName).toLowerCase(
                                            )) != -1) {
            player.addClip(fileName,pixelPosition);
        } else {
            formatDialog.visible = true
        }
    }

    function delay(delayTime) {
        timer = new Timer();
        timer.interval = delayTime;
        timer.repeat = false;
        timer.start();
    }

    Column
    {
      id: column
      anchors.fill: parent
      anchors.margins: 20
      anchors.bottomMargin: 28
      anchors.rightMargin: 26
      Rectangle{
          width: mainWindow.width
          height: mainWindow.height * 0.1
      Button{
          id: opendrawer
          x: 0
          y: 0
          height: 40
          width: 40
          icon.color: "transparent"
          icon.source: "images/menu.png"
          onClicked: menu.visible = true
          background: Rectangle {
               implicitWidth: 40
               implicitHeight: 40
               opacity: enabled ? 1 : 0.3
               color: "#BFE5D9"
               border.color: "gainsboro"
               radius: 10
          }
      }
      }
        Player
        {
            id: player
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: parent.height * 0.6
            onDropped: importAudio(drop.text,drop.x)
        }

        Text
        {
            id: txt
            width: parent.width
            height: parent.height*0.2
            text: player.pos_ms
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MessageDialog
        {
            id: formatDialog
            visible: false
            title: qsTr("Unsupported file foramt.")
            text:
            {
                var mess = qsTr("Supported formats are: ")
                for (var i = 0; i < supportedExtensions.length - 1; i++)
                {
                    mess += supportedExtensions[i] + ", "
                }
                mess += supportedExtensions[supportedExtensions.length - 1] + "."
            }
            standardButtons: StandardButton.Close
            icon: StandardIcon.Warning
            modality: Qt.ApplicationModal
        }
        ButtonLine
        {
            id: buttonline
            width: parent.width*0.2
            anchors.horizontalCenter: parent.horizontalLeft
            height: parent.height*0.3
            color: "white"
            anchors.left: parent.left
            onDel: player.deleteSelectedClip()
            onAddNote: {
                if(player.addNoteAtHandlePos(noteText) === false)
                {
                    buttonline.restoreLastNote()
                }
            }
        }

    }
    Rectangle{
        id:about_text
        x: 0
        y: 100
        width:mainWindow.width
        height: mainWindow.height/2 + 30
        color: "#BFE5D9"
        visible: false
        border.color: "gainsboro"
        Text{
            x: 10
            y: 50
            text: "This application is designed for simple and quick audio editing.
We want the users to be able to capture their thougts, ideas and
inspirations, and to be able to make simple editing on them. We
offer a small range of editing tools, which include cutting
samples, joining samples.Here is a quick overview
of our tools.
Adding audio: You can drag and drop your audio, add it through
menu item Edit->Import audio, or you can record it directly
in the app by clicking on the microphone button.
Playing audio: You can play and stop the audio, by pressing
the play button. You can also jump to the beginning or the end
of the sample, by clicking on the forward/backward arrows.
Editing: Audio is cut to the right to the position where the
marker is put will be deleted when you press the icon of scissors.
You can delete the whole clip by pressing the trashcan.
A note is added on the time where marker is, and by pressing
notes. Working with files:You can save your audio sample,
and your whole project in the menubar Project->Save.
You can also open an existing project, in Project->Open."
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        Button{
            id: close
            x: about_text.width-close.width*2
            y: 13
            width: 31
            height: 21
            text: qsTr("X")
            highlighted: false
            flat: false
            autoRepeat: false
            onClicked: {
                about_text.visible = false
            }
            onHoveredChanged:  hovered ? close.opacity = 0.7 : close.opacity = 1;
            background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 40
                        color: close.down ? "#d6d6d6" : "ghostwhite"
                        border.color: "gainsboro"
                        border.width: 1
                        radius: 4
                    }
        }
    }
    TabBar
    {
        id: tabBar
        x: 131
        y: 388
        width: 240
    }
    FileDialog {
        id: importDialog
        title: qsTr("Please choose an audio file")
        nameFilters: [ "Supported containers (*.mp3 *.wav *.aac *.m4a)", "All files (*)" ]
        folder: shortcuts.music
        selectExisting: true
        modality: Qt.ApplicationModal
        onAccepted: {
            importAudio(importDialog.fileUrl.toString(),0)
        }
    }
    ObjectModel
    {
        id: openedProjectModel
        property string filePath: ""
        property ClipListModel clips: player.clipList
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
