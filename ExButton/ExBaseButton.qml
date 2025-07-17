import QtQuick

Rectangle {
    id: baseButton

    //长按事件触发的事件阈值属性(毫秒)
    property real longPressThreshold: 1000
    //是否按下属性
    property bool down: clickedEvent.pressed

    //是否启用悬浮属性
    property bool enabledHovered: true
    //悬浮属性
    property bool hovered: hoveredEvent.hovered

    //背景颜色
    property color backgroundColor: color
    //悬浮颜色
    property color hoveredColor: "lightblue"

    //单击信号
    signal clicked(eventPoint point, int button)
    //双击信号
    signal doubleClicked(eventPoint point, int button)
    //点击取消信号
    signal canceled(eventPoint point)
    //长按信号
    signal longPressed

    antialiasing: true

    TapHandler {
        id: clickedEvent
        longPressThreshold: baseButton.longPressThreshold
        onCanceled: point => {
            baseButton.canceled(point);
        }
        onDoubleTapped: (point, button) => {
            baseButton.doubleClicked(point, button);
        }
        onSingleTapped: (point, button) => {
            baseButton.clicked(point, button);
        }
        onLongPressed: {
            baseButton.longPressed();
        }
    }
    HoverHandler {
        id: hoveredEvent
        enabled: baseButton.enabledHovered
    }
}
