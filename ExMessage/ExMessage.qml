import QtQuick
import QtQuick.Controls as T
import Qt5Compat.GraphicalEffects
import "../ExButton"

T.Popup {
    id: exMessage

    //左侧图标距离左侧边界的距离
    property real iconToLeftBorderMargin: 25

    //图标是否显示
    property bool showIcon: true

    //关闭按钮是否显示
    property bool showClose: true

    //关闭按钮的背景颜色
    property color closeButtonColor: "transparent"

    //关闭时间(毫秒)
    property int closeTimeout: 2000

    //文本是否居中显示
    property bool center: false

    //图标到内容文本的距离
    property real iconToTextMargin: 10

    //内容文本
    property string text: "空"
    //内容文本颜色
    property color textColor: "black"
    //内容文本字体采用父类的字体
    font: Qt.font({
        pixelSize: 14
    })
    //背景矩形圆角
    property real radius: 8
    //背景矩形边框颜色
    property color borderColor
    //背景矩形边框宽度
    property int borderWider: 0

    //消息提示类型
    property int type: ExMessage.MessageType.Success
    enum MessageType {
        Success,
        Warning,
        Info,
        Error
    }

    //用于确定通知对象在通知管理器里队列的索引
    property int index: 0
    // 目标垂直位置
    property real newPosition: 20

    onClosed: {
        if (closeTimer.running)
            closeTimer.stop();
    }

    //根据类型决定图标来源
    function getSource(type): url {
        if (type === ExMessage.MessageType.Success)
            return "file:///E:/ExUI/ExMessage/success.png";
        else if (type === ExMessage.MessageType.Warning)
            return "file:///E:/ExUI/ExMessage/warning.png";
        else if (type === ExMessage.MessageType.Info)
            return "file:///E:/ExUI/ExMessage/info.png";
        else if (type === ExMessage.MessageType.Error)
            return "file:///E:/ExUI/ExMessage/error.png";
        else
            return "icon source error";
    }

    //根据类型决定背景颜色
    function getColor(type) {
        if (type === ExMessage.MessageType.Success)
            return "#E5FAE1";
        else if (type === ExMessage.MessageType.Warning)
            return "#FFFEE6";
        else if (type === ExMessage.MessageType.Info)
            return "#E5F9FF";
        else if (type === ExMessage.MessageType.Error)
            return "#FFF2F0";
        else
            return "getColor error";
    }

    implicitWidth: 400
    implicitHeight: 40
    opacity: 1
    x: (parent.width - width) / 2
    y: newPosition
    z: 1000
    closePolicy: T.Popup.NoAutoClose

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: 200
        }
    }
    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1.0
            to: 0.0
            duration: 200
        }
    }

    // 位置变化动画 - 当通知位置改变时的平滑过渡
    Behavior on y {
        NumberAnimation {
            duration: 300  // 动画持续时间300毫秒
            easing.type: Easing.OutCubic  // 缓动类型
        }
    }

    background: Rectangle {
        id: bg
        color: exMessage.getColor(exMessage.type)
        radius: exMessage.radius
        border.width: exMessage.borderWider
        border.color: exMessage.borderColor
        // 阴影效果 - 为通知添加立体感
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 2
            radius: 10
            samples: 16
            color: "#30000000"  // 半透明黑色阴影
        }
    }

    contentItem: Item {
        id: newContent
        anchors.fill: parent

        Row {
            spacing: exMessage.iconToTextMargin
            width: parent.width - closeButton.width - 30
            clip: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: exMessage.center ? undefined : parent.left
            anchors.leftMargin: exMessage.center ? 0 : exMessage.iconToLeftBorderMargin
            anchors.horizontalCenter: exMessage.center ? parent.horizontalCenter : undefined
            Image {
                id: icon
                asynchronous: true
                visible: exMessage.showIcon
                source: exMessage.getSource(exMessage.type)
                sourceSize: Qt.size(16, 16)
                fillMode: Image.PreserveAspectFit
            }

            T.Label {
                id: content_
                color: exMessage.textColor
                text: qsTr(exMessage.text)
                font: exMessage.font
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
        ExButton {
            id: closeButton
            visible: exMessage.showClose && (!exMessage.center)
            width: 20
            height: 20
            radius: height / 2
            display: ExButton.DisplayMode.IconOnly
            source: hovered ? "file:///E:/ExUI/ExMessage/closeBefore.png" : "file:///E:/ExUI/ExMessage/closeAfter.png"
            sourceSize: Qt.size(16, 16)
            anchors.left: parent.left
            anchors.leftMargin: exMessage.width - 20
            anchors.verticalCenter: parent.verticalCenter
            color: hovered ? "#EE3333" : exMessage.closeButtonColor
            onClicked: {
                exMessage.close();
            }
        }
    }

    Timer {
        id: closeTimer
        interval: exMessage.closeTimeout
        running: true
        repeat: true
        onTriggered: {
            exMessage.close();
        }
    }
}
