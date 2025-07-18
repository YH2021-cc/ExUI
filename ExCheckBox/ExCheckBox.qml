/**
    说明:
        如果不需要边框,那么使用iconSize和font.pixelSize来控制大小
        如果需要边框还要通过width/height加上iconSize/pixelSize来控制大小
 */

import QtQuick
import QtQuick.Controls.Basic as T

T.CheckBox {
    id: exCheckBox

    //未选中的图标来源
    property url uncheckedSource
    //部分选中的图标来源
    property url partiallyCheckedSource
    //选中的图标来源
    property url checkedSource
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

    //根据三态检查获取图标源
    function getSource() {
        if (exCheckBox.checkState === Qt.Unchecked)
            return uncheckedSource;
        if (exCheckBox.checkState === Qt.PartiallyChecked)
            return partiallyCheckedSource;
        if (exCheckBox.checkState === Qt.Checked)
            return checkedSource;
    }

    //重写indicator
    indicator: Item {
        id: cusIndicator
        implicitWidth: parent.width
        implicitHeight: parent.height
        Rectangle {
            id: borderRect
            visible: exCheckBox.hasBorder
            antialiasing: true
            radius: exCheckBox.radius
            border.width: exCheckBox.borderWidth
            border.color: exCheckBox.borderColor
            anchors.fill: parent
        }
        //图标
        Image {
            id: indicatorIcon
            asynchronous: true
            fillMode: Image.PreserveAspectFit
            source: exCheckBox.getSource()
            sourceSize: exCheckBox.iconSize
            anchors.left: borderRect.left
            anchors.leftMargin: exCheckBox.iconToLeftBorderSpacing
            anchors.verticalCenter: borderRect.verticalCenter
        }
        //文本
        T.Label {
            id: indicatorText
            text: exCheckBox.text
            color: exCheckBox.textColor
            font: exCheckBox.font
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.left: indicatorIcon.right
            anchors.leftMargin: exCheckBox.itSpacing
            anchors.verticalCenter: indicatorIcon.verticalCenter
        }
    }
}
