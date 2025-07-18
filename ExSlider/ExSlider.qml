/**
        注意:垂直方向的坐标计算不可忘!!!!
 */

import QtQuick
import QtQuick.Controls as T

T.Slider {
    id: exSlider

    //背景矩形圆角
    property real radius: 8
    //背景矩形颜色
    property color backgroundRectColor: "#E4E7ED"
    //背景矩形子矩形颜色
    property color subBackgroundRectColor: "#409EFF"

    //自定义句柄颜色
    property color handleColor: "#ffffff"
    //自定义句柄边框颜色
    property color handleBorderColor: "#56A9FF"
    //自定义句柄边框宽度
    property int handleBorderWidth: 1
    //自定义句柄尺寸
    property real handleSize: 16

    implicitWidth: 200
    implicitHeight: 30

    background: Rectangle {
        id: exSliderBackgroundRect
        x: exSlider.orientation === Qt.Horizontal ? exSlider.leftPadding : exSlider.topPadding
        y: exSlider.orientation === Qt.Horizontal ? (exSlider.topPadding + exSlider.availableHeight / 2 - height / 2) : (exSlider.leftPadding + exSlider.availableHeight / 2 - height / 2)
        implicitHeight: parent.implicitHeight
        implicitWidth: parent.implicitWidth
        radius: exSlider.radius
        color: exSlider.backgroundRectColor
        Rectangle {
            x: 0
            y: exSlider.orientation === Qt.Horizontal ? 0 : parent.height - height
            width: exSlider.orientation === Qt.Horizontal ? exSlider.visualPosition * exSlider.width : parent.width
            height: exSlider.orientation === Qt.Horizontal ? parent.height : (1 - exSlider.visualPosition) * exSlider.height
            radius: exSliderBackgroundRect.radius
            color: exSlider.subBackgroundRectColor
        }
    }
    // 自定义滑动条的手柄部分
    handle: Rectangle {
        id: exSliderHandle

        function getX(): real {
            if (exSlider.orientation === Qt.Horizontal)
                return exSlider.leftPadding + exSlider.visualPosition * (exSlider.availableWidth - exSliderHandle.width);
            else {
                return exSlider.topPadding + (exSlider.availableWidth - exSliderHandle.width) / 2;
            }
        }
        function getY(): real {
            if (exSlider.orientation === Qt.Horizontal)
                return exSlider.topPadding + exSlider.availableHeight / 2 - exSliderHandle.height / 2;
            else {
                return exSlider.leftPadding + exSlider.visualPosition * (exSlider.availableHeight - exSliderHandle.height);
            }
        }

        // 计算手柄的x坐标，根据滑动条当前位置和可用宽度
        x: getX()
        // exSlider
        y: getY()
        implicitWidth: exSlider.handleSize                                          // 设置手柄的默认宽度
        implicitHeight: exSlider.handleSize                                       // 设置手柄的默认高度
        color: exSlider.handleColor                                            // 设置手柄的颜色为白色
        border.width: exSlider.handleBorderWidth                                            // 设置手柄边框宽度
        border.color: exSlider.handleBorderColor                                  // 设置手柄边框颜色为蓝色
        radius: implicitHeight / 2                                 // 设置手柄的圆角半径，使其成为圆形
        // 当鼠标悬停在手柄上时的放大动画
        ScaleAnimator {
            target: exSliderHandle                                     // 动画目标为手柄
            from: 1                                                // 初始缩放比例
            to: 1.2                                                // 目标缩放比例
            duration: 100                                          // 动画持续时间(毫秒)
            running: hoverHandler.hovered                          // 当鼠标悬停时运行动画
        }
        // 当鼠标离开手柄时的缩小动画
        ScaleAnimator {
            target: exSliderHandle                                     // 动画目标为手柄
            from: 1.2                                              // 初始缩放比例
            to: 1                                                  // 目标缩放比例
            duration: 100                                          // 动画持续时间(毫秒)
            running: !hoverHandler.hovered                         // 当鼠标离开时运行动画
        }
        // 处理鼠标悬停事件
        HoverHandler {
            id: hoverHandler
        }
    }
}
