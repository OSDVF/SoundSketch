import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Window 2.14
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.3
import QtMultimedia 5.0


//AudiorecorderForm {
Popup {
        id: audioRecorder
//        x: 60
//        y: 60
        //color: "#9e9e9e"
        //radius: 10
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

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
            onClicked: saveDialog.open()
        }

        Item {
            Timer {
                id:timer
                interval: 100; running: false; repeat: true
                onTriggered: {
                    time.text = "Recording: " + Math.round(startTime*100)/100
                    startTime+=0.1
                }
            }

            Text {
                id: time
                x: 92
                y: 0
                width: 415
                height: 249
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom
            }
        }
        Button {
            id: recordButton
            x: audioRecorder.width/2 + recordButton.width/2
            y: 160
            visible: true
            text: qsTr("Record")
            clip: false
            onClicked: {
                if(timer.running == false)
                {
                    timer.start()
                    recordButton.text = qsTr("Stop")
                }
                else
                {
                    timer.stop()
                    recordButton.text = qsTr("Record")
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
            onClicked: audiorecorder.visible = false
        }


    }
//}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
