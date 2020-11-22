import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

ApplicationWindow
{
    width: 1000
    height: 480
    visible: true
    title: qsTr("Hello World")

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
            height: parent.height*0.5
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
    }
    TabBar
    {
        id: tabBar
        x: 131
        y: 388
        width: 240
    }
}
