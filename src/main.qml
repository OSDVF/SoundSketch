import QtQuick 2.14
import QtQuick.Window 2.14
import QtQml.Models 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
//import Qt.labs.platform 1.1

ApplicationWindow
{
    id: mainWindow
    width: 1000
    height: 480
    visible: true
    title: qsTr("Hello World")

    menuBar: MenuBar {
        FileDialog {
            id: saveDialog
            title: "Save Dialog"
            selectMultiple : false
            selectExisting: false
        }
        Menu {

            title: qsTr("&Project")
            Action { text: qsTr("&New...") }
            Action { text: qsTr("&Open..."); onTriggered: importDialog.open()}
            Action { text: qsTr("&Save...");onTriggered: saveDialog.open() }
            MenuSeparator { }
            Action { text: qsTr("&Quit"); onTriggered: Qt.quit() }
        }
        Menu {
            title: qsTr("&Edit")
            Action
            {
                text: qsTr("&Import Audio")
                onTriggered: importDialog.open()
            }
            Action { text: qsTr("&Cut") }
            Action { text: qsTr("&Copy") }
            Action { text: qsTr("&Paste") }
        }
        Menu {
            title: qsTr("&Help")
            Action { text: qsTr("&About") }
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
            maxTime: openedProjectModel.totalDurationMs

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
            title: qsTr("Nepodporovaný formát souboru.")
            text:
            {
                var mess = qsTr("Podporované formáty jsou: ")
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
            //y: 400
            width: parent.width*0.2
            anchors.horizontalCenter: parent.horizontalLeft
            //anchors.top: parent.verticalCenter
            height: parent.height*0.3
            color: "#ffffff"
            anchors.left: parent.left
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
        //selectExisting: true
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

        //Computed properties
        readonly property real totalDurationMs:
        {
            if (clips.count == 0)
                return 50000 //Default for empty projects

            var lastClip = clips.get(clips.count - 1)

            return lastClip.posMs + lastClip.durationMs
        }
        
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
