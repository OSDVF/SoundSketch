import QtQuick 2.14
import QtQuick.Window 2.14
import QtQml.Models 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

ApplicationWindow
{
    width: 1000
    height: 480
    visible: true
    title: qsTr("Hello World")

    function basename(fileName)
    {
        return (fileName.slice(fileName.lastIndexOf("/") + 1))
    }
    function extension(fileName)
    {
        return (fileName.slice(fileName.lastIndexOf(".") + 1))
    }

    readonly property var supportedExtensions: ["mp3", "wav", "aac"]
    menuBar: MenuBar {
        Menu {
            title: qsTr("&Project")
            Action { text: qsTr("&New...") }
            Action { text: qsTr("&Open...") }
            Action { text: qsTr("&Save") }
            Action { text: qsTr("&Save As...") }
            MenuSeparator { }
            Action { text: qsTr("&Quit") }
        }
        Menu {
            title: qsTr("&Edit")
            Action { text: qsTr("&Cut") }
            Action { text: qsTr("&Copy") }
            Action { text: qsTr("&Paste") }
        }
        Menu {
            title: qsTr("&Help")
            Action { text: qsTr("&About") }
        }
    }

    Column
    {
      id: column
      anchors.fill: parent
      anchors.margins: 20
      anchors.bottomMargin: 16
      anchors.rightMargin: 26

        Player
        {
            id: player
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: parent.height * 0.5
            maxTime: openedProjectModel.totalDurationMs

            onDropped:
            {
                var fileName = drop.text
                if (supportedExtensions.indexOf(extension(fileName).toLowerCase(
                                                    )) != -1) {
                    player.addClip(fileName,drop.x);
                } else {
                    formatDialog.visible = true
                }
            }
        }

        Text
        {
            id: txt
            width: parent.width
            height: parent.height*0.1
            text: player.pos_ms
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }

        Dialog
        {
            id: formatDialog
            visible: false
            title: qsTr("Nepodporovaný formát souboru.")
            modality: Qt.ApplicationModal

            contentItem: Rectangle
            {
                implicitWidth: 400
                implicitHeight: 100
                Text
                {
                    text:
                    {
                        var mess = qsTr("Podporované formáty jsou: ")
                        for (var i = 0; i < supportedExtensions.length - 1; i++)
                        {
                            mess += supportedExtensions[i] + ", "
                        }
                        mess += supportedExtensions[supportedExtensions.length - 1] + "."
                    }

                    anchors.centerIn: parent
                }
            }
        }
    }
    ButtonLine
    {
        id: buttonline
        y: 400
        width: parent.width*0.2
        anchors.horizontalCenter: parent.horizontalLeft
        height: parent.height*0.3
        color: "#ffffff"
        anchors.left: parent.left
    }
    TabBar
    {
        id: tabBar
        x: 131
        y: 388
        width: 240
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
