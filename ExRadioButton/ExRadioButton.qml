import QtQuick
import QtQuick.Controls as T

T.RadioButton {
    id: exRadioButton

    //图标来源
    property url source
    //图标大小
    property size iconSize: Qt.size(32, 32)
    //字体颜色
    property color textColor: "black"

    //图标和文本之间的间距
    property int itSpacing: 5

    //重写indicator
    indicator: Item {
        id: cusIndicator
        implicitWidth: parent.width
        implicitHeight: parent.height
        //图标
        Image {
            id: indicatorIcon
            asynchronous: true
            fillMode: Image.PreserveAspectFit
            source: exRadioButton.source
            sourceSize: exRadioButton.iconSize
        }
        //文本
        T.Label {
            id: indicatorText
            text: exRadioButton.text
            color: exRadioButton.textColor
            font: exRadioButton.font
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.left: indicatorIcon.right
            anchors.leftMargin: exRadioButton.itSpacing
            anchors.verticalCenter: indicatorIcon.verticalCenter
        }
    }
}
