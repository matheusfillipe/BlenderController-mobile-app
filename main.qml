import QtQuick 2.9
import QtQuick.Controls 2.2
import QtWebSockets 1.1
import QtSensors 5.0

ApplicationWindow {
    id: applicationWindow
    visible: true
    width: 640
    height: 480
    title: qsTr("Blender Controller")

    WebSocket {
        id: sock
        url: "ws://192.168.1.101:9845"

        onStatusChanged: {
            if (sock.status == WebSocket.Error) {
                sock.active = false
                sock.active = true
                console.log("Connection error")

            } else if (sock.status == WebSocket.Open) {
                console.log("connected...")
                button.text = qsTr("Stop")


            } else if (sock.status == WebSocket.Closed) {
                sock.active = false
                button.text = qsTr("Start")
                 console.log("Connection Closed")

            }
        }
        active: false

    }

    Gyroscope{
        id: gyro
        active: true
        property real hasMoved: 0
            onReadingChanged: {

            hasMoved= Math.abs(reading.x) + Math.abs(reading.y) + Math.abs(reading.z) >=5.00


        }
    }

      RotationSensor {
        id: tilt
        active: sock.active

        onReadingChanged: {
        if(gyro.hasMoved){
             //   console.log(gyro.hasMoved)
  //            console.log(
//                    "x is " +  reading.x.toFixed(2)+
//                    "\ny is" + reading.y.toFixed(2) +
//                    "\nz is " + reading.z.toFixed(2)
//                   )


            //sock.sendTextMessage("\"{'x': \'" + reading.z.toFixed(2) + "\','y': \'" + reading.x.toFixed(2) + "\', 'z': \'" + reading.y.toFixed(2) + "\'}\"")
           sock.sendTextMessage(JSON.stringify({'x':+ reading.z.toFixed(2), 'y': reading.x.toFixed(2), 'z': reading.y.toFixed(2)}))
        }
        }
    }

    Button {
        id: button
        text: qsTr("Start")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        onClicked: {
            sock.active = !sock.active
        }
    }

    ToolBar {
        id: toolBar
        x: 125
        z:0
        width: 360
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            id: label
            text: qsTr("Status:")
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 22
            anchors.right: busyIndicator.left
            anchors.rightMargin: 10

        }

        BusyIndicator {
            id: busyIndicator
            x: 295
            y: 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 5
            running: button.text === qsTr("Start")

        }
        Image {
            id: green
            source: "green.png"
            x: 295
            y: 0
            z:5
            width: 60
            height: 47
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 5
            visible: button.text === qsTr("Stop")

// !busyIndicator.running

        }

        Label {
            id: label1
            y: 20
            text: qsTr("Blender Controller")
            font.pointSize: 24
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }

    }
}
