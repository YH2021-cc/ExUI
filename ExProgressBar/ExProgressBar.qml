import QtQuick
import QtQuick.Controls as T

T.ProgressBar {
    id: exProgressBar

    //背景和内容矩形的圆角
    property int radius: 8

    //自定义背景颜色和内容颜色
    property color backgroudColor: "#E9E9E9"
    property color contentColor: "#3C9CFF"

    //百分比文本显示
    property bool percentageDisplayed: false
    //百分比文本字体
    property font percentageFont: Qt.font({
        pixelSize: exProgressBar.height - 2
    })
    //百分比文本颜色
    property color percentageColor: contentRect.width < exProgressBar.width / 2 ? "black" : "white"

    //默认宽度
    implicitWidth: 300
    //默认高度
    implicitHeight: 16

    //自定义背景
    background: Rectangle {
        id: bgRect
        width: exProgressBar.width
        height: exProgressBar.height
        radius: exProgressBar.radius
        color: exProgressBar.backgroudColor
    }
    //自定义内容
    contentItem: Item {
        id: content
        Rectangle {
            id: contentRect
            height: exProgressBar.height
            width: exProgressBar.visualPosition * exProgressBar.width
            radius: exProgressBar.radius
            color: exProgressBar.contentColor
        }
    }
    //进度百分比
    T.Label {
        id: percentage
        text: exProgressBar.value + "%"
        visible: exProgressBar.percentageDisplayed
        font: exProgressBar.percentageFont
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: exProgressBar.percentageColor
        anchors.centerIn: exProgressBar
    }
}
