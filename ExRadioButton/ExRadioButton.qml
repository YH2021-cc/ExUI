/**
    说明:
        如果不需要边框,那么使用iconSize和font.pixelSize来控制大小
        如果需要边框还要通过width/height加上iconSize/pixelSize来控制大小
 */

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
    //图标到左边界的距离
    property int iconToLeftBorderSpacing: 0
    //是否启用边框
    property bool hasBorder: false
    //边框矩形圆角
    property real radius: 8
    //边框颜色
    property color borderColor: "#409EFF"
    //边框宽度
    property int borderWidth: 2

    //重写indicator
    indicator: Item {
        id: cusIndicator
        implicitWidth: parent.width
        implicitHeight: parent.height
        Rectangle {
            id: borderRect
            visible: exRadioButton.hasBorder
            antialiasing: true
            radius: exRadioButton.radius
            border.width: exRadioButton.borderWidth
            border.color: exRadioButton.borderColor
            anchors.fill: parent
        }
        //图标
        Image {
            id: indicatorIcon
            asynchronous: true
            fillMode: Image.PreserveAspectFit
            source: exRadioButton.source
            sourceSize: exRadioButton.iconSize
            anchors.left: borderRect.left
            anchors.leftMargin: exRadioButton.iconToLeftBorderSpacing
            anchors.verticalCenter: borderRect.verticalCenter
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
