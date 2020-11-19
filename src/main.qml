import QtQuick 2.14
import QtQuick.Window 2.14

Window
{
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Column
    {
        anchors.fill: parent
        anchors.margins: 20

        Player
        {
            id: player
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: parent.height*0.6
        }
        Text
        {
            id: txt
            width: parent.width
            height: parent.height*0.4
            text: player.pos_ms
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
    }
}
