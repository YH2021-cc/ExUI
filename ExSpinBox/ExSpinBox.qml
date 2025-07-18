import QtQuick
import QtQuick.Controls as T

Rectangle {
    id: exSpinBox

    //重要属性
    //可接受的最小值
    property int minValue: 0
    //可接受的最大值
    property int maxValue: 99
    //当前值
    property int value: 0
    //步长
    property int stepSize: 1
    //是否循环(最大值+1=最小值)
    property bool wrap: false
    //是否实时更新
    property bool live: false

    //输入框属性
    //当前输入框显示文本
    readonly property string displayText: input.displayText
    //是否启用编辑
    property bool editable: false
    //自定义输入校验器
    property var validator: IntValidator {
        bottom: exSpinBox.minValue
        top: exSpinBox.maxValue
    }
    //输入框文本字体
    property font textFont
    //输入框文本颜色
    property color textColor: "black"
    //输入框背景颜色
    property color inputBackgroundColor: "#DCDFE6"

    //up/down矩形的宽高
    property real upWidth: 60
    property real upHeight: exSpinBox.height / 2

    //up矩形属性
    //边框颜色
    property color upRectBorderColor: "#DCDFE6"
    //边框宽度
    property int upRectBorderWidth: 1
    //填充颜色
    property color upColor: "#F5F7FA"
    //图标大小
    property size upSize: Qt.size(16, 16)
    //图标来源
    property url upSource
    //是否悬浮在矩形上
    property bool upHovered: upHoverHandle.hovered
    //是否点击矩形
    property bool upPressed: upTaphandle.pressed

    //down矩形属性
    //边框颜色
    property color downRectBorderColor: "#DCDFE6"
    //边框宽度
    property int downRectBorderWidth: 1
    //填充颜色
    property color downColor: "#F5F7FA"
    //图标大小
    property size downSize: Qt.size(16, 16)
    //图标来源
    property url downSource
    //是否悬浮在矩形上
    property bool downHovered: downHoverHandle.hovered
    //是否点击矩形
    property bool downPressed: downTaphandle.pressed

    //数值修改信号(键盘,鼠标)
    signal valueModified

    //将文本转换为数值函数
    function valueFromText(text, locale): int {
        return Number.fromLocaleString(locale, text);
    }
    //将数值转换为文本函数
    function textFromValue(value, locale): string {
        return Number(value).toLocaleString(locale, 'f', 0);
    }

    //递增stepSize函数
    function decrease() {
        if (exSpinBox.wrap === true) {
            if (exSpinBox.value <= exSpinBox.minValue) {
                exSpinBox.value = exSpinBox.maxValue;
                return;
            }
        } else {
            if (exSpinBox.value === exSpinBox.minValue) {
                downRect.isMinValue = true;
                return;
            }
        }
        if (exSpinBox.stepSize === undefined) {
            exSpinBox.value -= 1;
        } else {
            exSpinBox.value -= exSpinBox.stepSize;
            if (exSpinBox.value < exSpinBox.minValue)
                exSpinBox.value = exSpinBox.minValue;
        }
    }
    //递减stepSize函数
    function increase() {
        if (exSpinBox.wrap === true) {
            if (exSpinBox.value >= exSpinBox.maxValue) {
                exSpinBox.value = exSpinBox.minValue;
                return;
            }
        } else {
            if (exSpinBox.value === exSpinBox.maxValue) {
                upRect.isMaxValue = true;
                return;
            }
        }
        if (exSpinBox.stepSize === undefined) {
            exSpinBox.value += 1;
        } else {
            exSpinBox.value += exSpinBox.stepSize;
            if (exSpinBox.value > exSpinBox.maxValue)
                exSpinBox.value = exSpinBox.maxValue;
        }
    }

    //向上箭头按键按下信号
    Keys.onUpPressed: event => {
        if (event.key === Qt.Key_Up) {
            exSpinBox.increase();
            if (!upRect.isMaxValue)
                exSpinBox.valueModified();
        }
    }
    //向下箭头按键按下信号
    Keys.onDownPressed: event => {
        if (event.key === Qt.Key_Down) {
            exSpinBox.decrease();
            if (!downRect.isMinValue)
                exSpinBox.valueModified();
        }
    }

    //输入框对象
    T.TextField {
        id: input
        readOnly: exSpinBox.editable
        validator: exSpinBox.validator
        implicitWidth: exSpinBox.width - exSpinBox.upWidth
        implicitHeight: exSpinBox.height
        text: exSpinBox.textFromValue(exSpinBox.value, Qt.locale("Zh_CN"))
        font: exSpinBox.textFont
        color: exSpinBox.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.top: parent.top
        anchors.topMargin: 1
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 1
        background: Rectangle {
            topLeftRadius: exSpinBox.radius
            bottomLeftRadius: exSpinBox.radius
            color: exSpinBox.inputBackgroundColor
        }
        onEditingFinished: {
            exSpinBox.value = exSpinBox.valueFromText(text, Qt.locale());
        }
        onTextEdited: {
            if (exSpinBox.live === true) {
                exSpinBox.value = exSpinBox.valueFromText(text, Qt.locale());
            }
        }
    }
    //up矩形
    Rectangle {
        id: upRect
        topRightRadius: exSpinBox.radius
        color: exSpinBox.upColor
        border.width: exSpinBox.upRectBorderWidth
        border.color: exSpinBox.upRectBorderColor
        implicitHeight: exSpinBox.upHeight
        implicitWidth: exSpinBox.upWidth
        anchors.right: parent.right
        anchors.rightMargin: 1
        anchors.top: parent.top
        anchors.topMargin: 1

        //操作前是否已达最大值
        property bool isMaxValue: exSpinBox.value === exSpinBox.maxValue
        TapHandler {
            id: upTaphandle
            onSingleTapped: {
                exSpinBox.increase();
                if (!upRect.isMaxValue)
                    exSpinBox.valueModified();
            }
        }
        HoverHandler {
            id: upHoverHandle
        }
        Image {
            id: upItem
            asynchronous: true
            source: exSpinBox.upSource
            fillMode: Image.PreserveAspectFit
            sourceSize: exSpinBox.upSize
            anchors.centerIn: parent
        }
    }
    //down矩形
    Rectangle {
        id: downRect
        bottomRightRadius: exSpinBox.radius
        color: exSpinBox.downColor
        border.width: exSpinBox.downRectBorderWidth
        border.color: exSpinBox.downRectBorderColor
        anchors.right: parent.right
        anchors.rightMargin: 1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 1
        //操作前是否已达最小值
        property bool isMinValue: exSpinBox.value === exSpinBox.minValue
        implicitHeight: exSpinBox.upHeight
        implicitWidth: exSpinBox.upWidth
        TapHandler {
            id: downTaphandle
            onSingleTapped: {
                exSpinBox.decrease();
                if (!downRect.isMinValue)
                    exSpinBox.valueModified();
            }
        }
        HoverHandler {
            id: downHoverHandle
        }
        Image {
            id: downItem
            asynchronous: true
            source: exSpinBox.downSource
            fillMode: Image.PreserveAspectFit
            sourceSize: exSpinBox.downSize
            anchors.centerIn: parent
        }
    }
}
