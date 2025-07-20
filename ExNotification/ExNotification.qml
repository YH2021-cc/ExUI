import QtQuick
import QtQuick.Controls as T
import Qt5Compat.GraphicalEffects
import "../ExButton"

T.Popup {
    id: exNotification

    //启用图标
    property bool showIcon: true
    //左侧图标距离顶部边界的距离
    property real leftIconToTopBorderMargin: 20
    //左侧图标距离左侧边界的距离
    property real leftIconToLeftBorderMargin: 20

    //隐藏关闭按钮
    property bool showClose: true
    //关闭按钮的背景颜色
    property color closeButtonColor: "transparent"
    //关闭按钮的悬浮颜色
    property color closeButtonHoverColor: "#C0C4CC"
    //关闭按钮距离顶部边界的距离
    property real closeButtonToTopBorderMargin: 10
    //关闭按钮距离左侧边界的距离
    property real closeButtonToLeftBorderMargin: 314

    //是否启用自动关闭
    property bool autoClose: true
    //关闭时间(毫秒)
    property int closeTimeout: 3000

    //内容文本
    property string contentText: "空"
    //内容文本颜色
    property color contentTextColor: "black"
    //内容文本距离顶部边界的距离
    property real contentTextToTopBorderMargin: 48
    //内容文本距离左侧边界的距离
    property real contentTextToLeftBorderMargin: showIcon ? 54 : 20
    //内容文本字体采用父类的字体
    font: Qt.font({
        pixelSize: 14
    })
    //标题文本
    property string titleText: "标题"
    //标题文本颜色
    property color titleTextColor: "black"
    //标题文本字体
    property font titleTextFont: Qt.font({
        pixelSize: 16,
        bold: "true"
    })
    //标题文本距离顶部边界的距离
    property real titleTextToTopBorderMargin: 20
    //标题文本距离左侧边界的距离
    property real titleTextToLeftBorderMargin: showIcon ? 54 : 20

    //背景颜色
    property color backgroundColor: "white"
    //背景矩形圆角
    property real radius: 8
    //背景矩形边框颜色
    property color borderColor
    //背景矩形边框宽度
    property int borderWider: 0

    //用于确定通知对象在通知管理器里队列的索引
    property int index: 0
    // 目标垂直位置
    property real newPosition: 20

    //通知的类型
    property int type: ExNotification.NotificationType.Success
    //通知类型枚举
    enum NotificationType {
        Success,
        Warning,
        Info,
        Error
    }

    onClosed: {
        if (closeTimer.running)
            closeTimer.stop();
    }

    //根据类型决定图标
    function getSource(type) {
        if (type === ExNotification.NotificationType.Success)
            return "file:///E:/ExUI/ExNotification/success.png";
        else if (type === ExNotification.NotificationType.Warning)
            return "file:///E:/ExUI/ExNotification/warning.png";
        else if (type === ExNotification.NotificationType.Info)
            return "file:///E:/ExUI/ExNotification/info.png";
        else if (type === ExNotification.NotificationType.Error)
            return "file:///E:/ExUI/ExNotification/error.png";
        else
            return "icon source error";
    }

    x: parent.width - width - 20  // 右对齐，距离右边缘20像素
    y: newPosition  // 垂直位置由管理器控制
    implicitWidth: 340
    implicitHeight: 90
    opacity: 1
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

    //y坐标变化动画,当通知位置改变时的平滑过渡
    Behavior on y {
        NumberAnimation {
            duration: 300  // 动画持续时间300毫秒
            easing.type: Easing.OutCubic  // 缓动类型
        }
    }

    background: Rectangle {
        id: bg
        color: exNotification.backgroundColor
        radius: exNotification.radius
        border.width: exNotification.borderWider
        border.color: exNotification.borderColor
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
        Image {
            id: icon
            asynchronous: true
            visible: exNotification.showIcon
            source: exNotification.getSource(exNotification.type)
            sourceSize: Qt.size(24, 24)
            fillMode: Image.PreserveAspectFit
            anchors.left: parent.left
            anchors.leftMargin: exNotification.leftIconToLeftBorderMargin
            anchors.top: parent.top
            anchors.topMargin: exNotification.leftIconToTopBorderMargin
        }

        T.Label {
            id: title
            color: exNotification.titleTextColor
            text: qsTr(exNotification.titleText)
            font: exNotification.titleTextFont
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.left: parent.left
            anchors.leftMargin: exNotification.titleTextToLeftBorderMargin
            anchors.top: parent.top
            anchors.topMargin: exNotification.titleTextToTopBorderMargin
        }

        T.Label {
            id: content_
            color: exNotification.contentTextColor
            text: qsTr(exNotification.contentText)
            font: exNotification.font
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.left: parent.left
            anchors.leftMargin: exNotification.contentTextToLeftBorderMargin
            anchors.top: parent.top
            anchors.topMargin: exNotification.contentTextToTopBorderMargin
        }
        ExButton {
            id: closeButton
            visible: exNotification.showClose
            width: 20
            height: 20
            radius: height / 2
            display: ExButton.DisplayMode.IconOnly
            source: "file:///E:/ExUI/ExNotification/closeAfter.png"
            sourceSize: Qt.size(16, 16)
            anchors.left: parent.left
            anchors.leftMargin: exNotification.closeButtonToLeftBorderMargin
            anchors.top: parent.top
            anchors.topMargin: exNotification.closeButtonToTopBorderMargin
            color: hovered ? exNotification.closeButtonHoverColor : exNotification.closeButtonColor
            onClicked: {
                exNotification.close();
            }
        }
    }

    Timer {
        id: closeTimer
        interval: exNotification.closeTimeout
        running: exNotification.autoClose
        repeat: true
        onTriggered: {
            exNotification.close();
        }
    }
}
