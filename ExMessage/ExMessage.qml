/**
    注意:消息的x和y固定为让消息在父窗口居中显示(x)的坐标

 */

import QtQuick
import QtQuick.Controls as T
import "../ExButton"

T.Popup {
    id: exMessage

    //左侧图标来源
    property url leftSource: ""
    //左侧图标大小
    property size leftIconSize: Qt.size(20, 20)
    //左侧图标距离顶部边界的距离
    property real leftIconToTopBorderMargin: 18
    //左侧图标距离左侧边界的距离
    property real leftIconToLeftBorderMargin: 16

    //关闭按钮图标源
    property url closeButtonSource: ""
    //关闭按钮的大小:默认为图标大小
    property size closeButtonSize: closeButtonIconSize
    //关闭按钮图标大小
    property size closeButtonIconSize: Qt.size(12, 12)
    //关闭按钮的背景颜色
    property color closeButtonColor: "transparent"
    //关闭按钮距离顶部边界的距离
    property real closeButtonToTopBorderMargin: 16
    //关闭按钮距离左侧边界的距离
    property real closeButtonToLeftBorderMargin: 411

    //是否启用自动关闭
    property bool autoClose: true
    //关闭时间(毫秒)
    property int closeTimeout: 3000

    //内容文本
    property string contentText: "空"
    //内容文本颜色
    property color contentTextColor: "black"
    //内容文本距离顶部边界的距离
    property real contentTextToTopBorderMargin: 44
    //内容文本距离左侧边界的距离
    property real contentTextToLeftBorderMargin: 44
    //内容文本字体采用父类的字体

    //标题文本
    property string titleText: "标题"
    //标题文本颜色
    property color titleTextColor: "black"
    //标题文本字体
    property font titleTextFont
    //启用标题
    property bool hasTitle: false
    //标题文本距离顶部边界的距离
    property real titleTextToTopBorderMargin: 16
    //标题文本距离左侧边界的距离
    property real titleTextToLeftBorderMargin: 44

    //背景颜色
    property color backgroundColor
    //背景矩形圆角
    property real radius: 8
    //背景矩形边框颜色
    property color borderColor
    //背景矩形边框宽度
    property int borderWider: 0

    implicitWidth: 455
    implicitHeight: 40
    x: (parent.width - width) / 2
    y: 0

    enter: Transition {
        ParallelAnimation {
            NumberAnimation {
                property: "y"
                from: 0
                to: Math.round((exMessage.parent.height - exMessage.height) / 4)
                duration: 200
            }
            NumberAnimation {
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 200
            }
        }
    }
    exit: Transition {
        ParallelAnimation {
            NumberAnimation {
                property: "y"
                from: Math.round((exMessage.parent.height - exMessage.height) / 4)
                to: 0
                duration: 200
            }
            NumberAnimation {
                property: "opacity"
                from: 1.0
                to: 0.0
                duration: 200
            }
        }
    }

    background: Rectangle {
        id: bg
        color: exMessage.backgroundColor
        radius: exMessage.radius
        border.width: exMessage.borderWider
        border.color: exMessage.borderColor
    }

    contentItem: Item {
        id: newContent
        anchors.fill: parent
        Image {
            id: icon
            asynchronous: true
            source: exMessage.leftSource
            sourceSize: exMessage.leftIconSize
            fillMode: Image.PreserveAspectFit
            anchors.left: parent.left
            anchors.leftMargin: exMessage.leftIconToLeftBorderMargin
            anchors.top: parent.top
            anchors.topMargin: exMessage.leftIconToTopBorderMargin
        }

        T.Label {
            id: title
            visible: exMessage.hasTitle
            color: exMessage.titleTextColor
            text: qsTr(exMessage.titleText)
            font: exMessage.titleTextFont
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.left: parent.left
            anchors.leftMargin: exMessage.titleTextToLeftBorderMargin
            anchors.top: parent.top
            anchors.topMargin: exMessage.titleTextToTopBorderMargin
        }

        T.Label {
            id: content_
            color: exMessage.contentTextColor
            text: qsTr(exMessage.contentText)
            font: exMessage.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.left: parent.left
            anchors.leftMargin: exMessage.contentTextToLeftBorderMargin
            anchors.top: parent.top
            anchors.topMargin: exMessage.contentTextToTopBorderMargin
        }
        ExButton {
            id: closeButton
            visible: source !== ""
            width: exMessage.closeButtonSize.width
            height: exMessage.closeButtonIconSize.height
            display: ExButton.DisplayMode.IconOnly
            source: exMessage.closeButtonSource
            sourceSize: exMessage.closeButtonIconSize
            anchors.left: parent.left
            anchors.leftMargin: exMessage.closeButtonToLeftBorderMargin
            anchors.top: parent.top
            anchors.topMargin: exMessage.closeButtonToTopBorderMargin
            color: exMessage.closeButtonColor
            onClicked: {
                exMessage.close();
            }
        }
    }

    Timer {
        id: closeTimer
        interval: exMessage.closeTimeout
        running: exMessage.autoClose
        repeat: true
        onTriggered: {
            exMessage.close();
        }
    }
}
