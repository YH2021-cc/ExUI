import QtQuick
import QtQuick.Controls as T

T.TextField {
    id: exTextField

    //启用鼠标点击事件穿透
    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        onClicked: mouse => {
            bg.focus = true;
            mouse.accepted = false;
            // 设置点击时强行获取焦点,否则可能导致输入框焦点被转以后再次点击无效
            exTextField.forceActiveFocus();
        }
    }

    //左侧图标来源
    property url leftIconSource: ""
    //左侧图标大小
    property size leftIconSize: Qt.size(32, 32)
    //左侧图标距离左边界的大小
    property int leftIconToBorder: 10
    //右侧图标来源
    property url rightIconSource: ""
    //右侧图标大小
    property size rightIconSize: Qt.size(32, 32)
    //右侧图标距离右边界的大小
    property int rightIconToBorder: 10
    //自定义外观属性
    //圆角
    property real radius: 8
    //边框宽度
    property int borderWidth: 2
    //边框默认颜色
    property color borderColor: "#DCDFE6"
    //边框的有焦点颜色
    property color borderFocusColor: "#3071f2"
    //背景色
    property color backgroundColor: "#ffffff"

    background: Rectangle {
        id: bg
        radius: exTextField.radius
        border.width: exTextField.borderWidth
        border.color: exTextField.activeFocus ? exTextField.borderFocusColor : exTextField.borderColor
        color: exTextField.backgroundColor
        Image {
            id: leftIcon
            asynchronous: true
            fillMode: Image.PreserveAspectFit
            source: exTextField.leftIconSource
            sourceSize: exTextField.leftIconSize
            visible: source !== "" //只在有正确的图标时才显示
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: exTextField.leftIconToBorder
        }
        //此处可以使用ExButton代替
        Image {
            id: rightIcon
            asynchronous: true
            source: exTextField.rightIconSource
            visible: source !== "" && exTextField.length > 0//只在有正确的图标以及字符数>0时才显示
            fillMode: Image.PreserveAspectFit
            sourceSize: exTextField.rightIconSize
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: exTextField.rightIconToBorder
            MouseArea {
                anchors.fill: parent
                enabled: true
                onClicked: {
                    exTextField.clear();
                }
            }
        }
    }
}
