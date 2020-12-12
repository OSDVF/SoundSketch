import QtQuick 2.14
import QtQuick.Window 2.14
import QtQml.Models 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
//import Qt.labs.platform 1.1
import itu.project.backend 1.0

ApplicationWindow
{
    property string copiedUrl: ""
    property bool isPlaying: false

    id: mainWindow
    width: 1000
    height: 480
    visible: true
    title: qsTr("Hello World")

    menuBar: MenuBar {
        background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    color: "#BFE5D9"
                    border.color: "gainsboro"
                    border.width: 1
                    radius: 5
                }
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
                    x: 10
                    text: qsTr("Congratulations, you successfully \n       saved your project!")
                }
            }

            onAccepted: console.log("Ok clicked")
        }
        Dialog {
            id: dialog2
            x: mainWindow.width / 2 - dialog.width/2
            y: mainWindow.height / 2 - dialog.height/2
            standardButtons: {
                if(openedProjectModel.clips.count > 0)
                {
                    return Dialog.Yes | Dialog.No
                }
                return Dialog.Ok
            }

            visible: false
            Text {
                y: 5
                text: {
                    if(openedProjectModel.clips.count>0)
                    {
                        return qsTr("Do you really want to discard your current project?")
                    }
                    else return qsTr("Successfully created new project")
                }
            }
            background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 40
                        color: "#BFE5D9"
                        border.color: "gainsboro"
                        border.width: 1
                        radius: 5
                    }
            onAccepted: {
                    player.deleteAllClips()
            }
        }
        Menu {

            title: qsTr("Project")
            Action { text: qsTr("New..."); onTriggered: { dialog2.visible = true}}
            Action { text: qsTr("Open..."); onTriggered: importDialog.open()}
            Action { text: qsTr("Save..."); onTriggered: dialog.visible = true }
            MenuSeparator { }
            Action { text: qsTr("Quit"); onTriggered: Qt.quit() }
        }
        Menu {
            title: qsTr("Edit")
            Action
            {
                text: qsTr("Import Audio")
                onTriggered: importDialog.open()
            }
            Action { text: qsTr("Cut"); onTriggered: {copiedUrl = player.getSelectedClipUrl(); player.deleteSelectedClip()}}
            Action { text: qsTr("Copy"); onTriggered: copiedUrl = player.getSelectedClipUrl()}
            Action { text: qsTr("Paste"); onTriggered: {
                    if(copiedUrl.length > 0)
                        player.addClipAtPos(copiedUrl, player.pos_ms)
                }
            }
        }

        Menu {
            title: qsTr("Help")
            Action { text: qsTr("About") ; onTriggered: about_text.visible = true}
        }
        delegate: MenuBarItem {
                id: menuBarItem

                contentItem: Text {
                    text: menuBarItem.text
                    font: menuBarItem.font
                    opacity: enabled ? 1.0 : 0.3

                    color: menuBarItem.highlighted ? "dimgray" : "black"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

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
        x: mainWindow.width/4
        y: 20
        width:450
        height: 400
        color: "#BFE5D9"
        visible: false
        border.color: "gainsboro"
        Text{
            x: 20
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
A note is added on the time where marker is, and by pressing notes.
Working with files:You can save your audio sample,
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
        property ListModel clips: player.clipList
    }

    Component.onCompleted:
    {
        buttonline.play.connect(player.play);
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
