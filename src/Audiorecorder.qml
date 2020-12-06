import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Window 2.14
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.3
import QtMultimedia 5.0
import QtQuick.Controls.Styles 1.4


//AudiorecorderForm {
Popup {
        id: audioRecorder
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    color:  "white"
                    border.color: "gainsboro"
                    border.width: 1
                    radius: 4
                }
        property double startTime: 0

        Label {
            id: label
            x: audioDeviceBox.x - label.width
            y: 95
            width: 76
            height: 34
            text: qsTr("Input:")
        }
        ComboBox {
            id: audioDeviceBox
            anchors.horizontalCenter: parent.horizontalCenter
            y: 81
            width: 134
            height: 40
            onHoveredChanged:  hovered ? audioDeviceBox.opacity = 0.7 : audioDeviceBox.opacity = 1;
            background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 40
                        color: button.down ? "#d6d6d6" : "#BFE5D9"
                        border.color: "gainsboro"
                        border.width: 1
                        radius: 4
                    }
            model: ListModel {
                    id: model
                    ListElement { text: "Default" }
                    ListElement { text: "Microphone" }
                    ListElement { text: "Headphones" }
                }
                onAccepted: {
                    if (find(editText) === -1)
                        model.append({text: editText})
                }
        }

        Button {
            id: outputButton
            x: audioRecorder.width/2 - outputButton.width
            y: 160
            text: qsTr("Save recording")
            onHoveredChanged:  hovered ? outputButton.opacity = 0.7 : outputButton.opacity = 1;
            onClicked: saveDialog.open()
            background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 40
                        color: button.down ? "#d6d6d6" : "#BFE5D9"
                        border.color: "gainsboro"
                        border.width: 1
                        radius: 4
                    }
        }



        Item {
            Timer {
                id:timer
                interval: 100; running: false; repeat: true
                onTriggered: {
                    time.text = "Recording: " + Math.round(startTime*100)/100
                    startTime+=0.1
                    if (Math.round(startTime%1) == 0)
                    {
                        red_dot.visible = true
                    }
                    else
                    {
                        red_dot.visible = false
                    }
                }
            }

            Text {
                id: time
                x: 20
                //y: 0
                width: 415
                height: 249
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom
            }
            Rectangle {
                x: 0
                y: time.y+time.height-15
                id: red_dot
                 width: 15
                 height: width
                 color: "red"
                 border.color: "red"
                 border.width: 1
                 radius: width*0.5
                 visible: false
            }
        }
        Button {
            id: recordButton
            x: audioRecorder.width/2 + recordButton.width/2
            y: 160
            visible: true
            text: qsTr("Record")
            clip: false
            onHoveredChanged:  hovered ? recordButton.opacity = 0.7 : recordButton.opacity = 1;
            onClicked: {
                if(timer.running == false)
                {
                    timer.start()
                    recordButton.text = qsTr("Stop")
                    red_dot.visible = true
                }
                else
                {
                    timer.stop()
                    recordButton.text = qsTr("Record")
                    red_dot.visible = false
                }
            }
            background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 40
                        color: button.down ? "#d6d6d6" : "#BFE5D9"
                        border.color: "gainsboro"
                        border.width: 1
                        radius: 4
                    }
            ButtonStyle {
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 25
                        border.width: control.activeFocus ? 2 : 1
                        border.color: "gainsboro"
                    }
            }
        }





        Button {
            id: close
            x: audioRecorder.width-close.width*2
            y: 13
            width: 31
            height: 21
            text: qsTr("X")
            highlighted: false
            flat: false
            autoRepeat: false
            onClicked: {
                startTime = 0
                time.text = ""
                audiorecorder.visible = false
            }
            onHoveredChanged:  hovered ? close.opacity = 0.7 : close.opacity = 1;
            background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 40
                        color: button.down ? "#d6d6d6" : "#BFE5D9"
                        border.color: "gainsboro"
                        border.width: 1
                        radius: 4
                    }
        }


    }
//}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
