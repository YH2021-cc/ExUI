import QtQuick
import QtQuick.Controls as T

Item {
    id: exSpinBox

    //重要属性
    property int minValue: 0
    property int maxValue: 99
    //当前值
    property int value: 0
    //步长
    property int stepSize: 1
    //是否循环(最大值+1=最小值)
    property bool wrap: false

    //背景矩形属性
    //圆角
    property real radius: 8
    //边框
    property color backgroundRectBorderColor: "#DCDFE6"
    property int backgroundRectBorderWidth: 0

    //输入框属性
    readonly property string displayText: input.displayText
    property bool editable: false
    property var validator: IntValidator {
        bottom: exSpinBox.minValue
        top: exSpinBox.maxValue
    }
    property font textFont
    property color textColor: "black"
    property color inputBackgroundColor: "#DCDFE6"

    //up/down矩形的宽高
    property real upWidth: 60
    property real upHeight: exSpinBox.height / 2

    //up矩形属性
    property color upRectBorderColor: "#DCDFE6"
    property int upRectBorderWidth: 1
    property color upColor: "#F5F7FA"
    property size upSize: Qt.size(24, 24)
    property url upSource
    property bool upHovered: upHoverHandle.hovered
    property bool upPressed: upTaphandle.pressed

    //down矩形属性
    property color downRectBorderColor: "#DCDFE6"
    property int downRectBorderWidth: 1
    property color downColor: "#F5F7FA"
    property size downSize: Qt.size(24, 24)
    property url downSource
    property bool downHovered: downHoverHandle.hovered
    property bool downPressed: downTaphandle.pressed

    signal valueModified

    function valueFromText(text: string, locale: Locale): int {
        return Number.fromLocaleString(locale, text);
    }

    function textFromValue(value: int, locale: Locale): string {
        return Number(value).toLocaleString(locale, 'f', 0);
    }

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

    Keys.onUpPressed: event => {
        if (event.key === Qt.Key_Up) {
            exSpinBox.increase();
            if (!upRect.isMaxValue)
                exSpinBox.valueModified();
        }
    }

    Keys.onDownPressed: event => {
        if (event.key === Qt.Key_Down) {
            exSpinBox.decrease();
            if (!downRect.isMinValue)
                exSpinBox.valueModified();
        }
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: exSpinBox.radius
        border.color: exSpinBox.backgroundRectBorderColor
        border.width: exSpinBox.backgroundRectBorderWidth
        color: "transparent"
    }

    T.TextField {
        id: input
        readOnly: exSpinBox.editable
        validator: exSpinBox.validator
        implicitWidth: exSpinBox.width - exSpinBox.upWidth
        implicitHeight: exSpinBox.height
        text: exSpinBox.textFromValue(exSpinBox.value, Qt.locale())
        font: exSpinBox.textFont
        color: exSpinBox.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.top: parent.top
        anchors.left: parent.left
        background: Rectangle {
            topLeftRadius: exSpinBox.radius
            bottomLeftRadius: exSpinBox.radius
            color: exSpinBox.inputBackgroundColor
        }
        onEditingFinished: {
            exSpinBox.value = exSpinBox.valueFromText(text, Qt.locale());
        }
    }
    Rectangle {
        id: upRect
        topRightRadius: exSpinBox.radius
        color: exSpinBox.upColor
        border.width: exSpinBox.upRectBorderWidth
        border.color: exSpinBox.upRectBorderColor
        implicitHeight: exSpinBox.upHeight
        implicitWidth: exSpinBox.upWidth
        anchors.left: input.right
        anchors.top: parent.top

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
    Rectangle {
        id: downRect
        bottomRightRadius: exSpinBox.radius
        color: exSpinBox.downColor
        border.width: exSpinBox.downRectBorderWidth
        border.color: exSpinBox.downRectBorderColor
        anchors.left: input.right
        anchors.top: upRect.bottom
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
