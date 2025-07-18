import QtQuick
import QtQuick.Controls as T

Item {
    id: exSwitch

    //图标来源
    property url source
    //图标大小
    property size iconSize: Qt.size(32, 32)
    //字体颜色
    property color textColor: "black"
    //文本
    property string text: "开关按钮"
    //文本字体
    property font textFont
    //图标和文本之间的间距
    property int itSpacing: 5
    //是否启用文本
    property bool hasText: false
    //是否选中
    property bool checked: false
    //是否启用悬浮属性
    property bool hoverEnabled: true
    property bool hovered: hoverhandle.hovered

    //点击信号
    signal clicked(eventPoint point, int button)

    //启用抗锯齿
    antialiasing: true
    //隐式宽度和高度
    implicitHeight: 50
    implicitWidth: 100

    //图标
    Image {
        id: indicatorIcon
        asynchronous: true
        fillMode: Image.PreserveAspectFit
        source: exSwitch.source
        sourceSize: exSwitch.iconSize
    }
    //文本
    T.Label {
        id: indicatorText
        text: exSwitch.text
        visible: exSwitch.hasText
        color: exSwitch.textColor
        font: exSwitch.textFont
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.left: indicatorIcon.right
        anchors.leftMargin: exSwitch.itSpacing
        anchors.verticalCenter: indicatorIcon.verticalCenter
    }
    TapHandler {
        id: tapHandler
        onTapped: (point, button) => {
            exSwitch.checked = !exSwitch.checked;
            exSwitch.clicked(point, button);
        }
    }
    HoverHandler {
        id: hoverhandle
    }
}
