import QtQuick
import QtQuick.Controls as T
import QtQuick.Layouts

Item {
    id: exDivider

    //图标源
    property url iconSource: ""
    //图标大小
    property size iconSize: Qt.size(32, 32)

    //文本内容
    property string text: "这是文本"
    //文本颜色
    property color textColor: "black"
    //文本字体
    property font textFont: Qt.font({
        pixelSize: 14
    })

    //内容类型
    property int type: ExDivider.DisplayType.Text
    enum DisplayType {
        Text,
        Icon
    }
    //内容和左右线的间隔
    property real margin: 10

    //内容坐标
    property int contentPosition: ExDivider.Position.Left
    enum Position {
        Left,
        Center,
        Right
    }

    //左线的颜色
    property color leftLineColor: "#DCDFE6"
    //右线的颜色
    property color rightLineColor: "#DCDFE6"
    //左右线的高度
    property real lineHeight: 1

    //是否只显示一条线
    property bool onlyDisplayOneLine: true
    //左线的长度
    property real leftLineWidth: 20

    RowLayout {
        id: layout

        //当前内容项
        property Item curContent: icon.visible ? icon : content

        spacing: exDivider.margin
        anchors.fill: parent
        layoutDirection: exDivider.contentPosition === ExDivider.Position.Right ? Qt.RightToLeft : Qt.LeftToRight

        Rectangle {
            id: leftLine
            Layout.fillWidth: true
            Layout.preferredWidth: getLineWidth()
            Layout.preferredHeight: exDivider.lineHeight
            color: exDivider.leftLineColor

            function getLineWidth() {
                if (exDivider.onlyDisplayOneLine)
                    return 0;

                switch (exDivider.contentPosition) {
                case ExDivider.Position.Center:
                    return (exDivider.width - layout.curContent.width - 2 * exDivider.margin) / 2;
                case ExDivider.Position.Left:
                case ExDivider.Position.Right:
                    return exDivider.leftLineWidth;
                }
            }
        }

        Image {
            id: icon
            visible: (exDivider.type === ExDivider.DisplayType.Icon && (!exDivider.onlyDisplayOneLine)) ? true : false
            asynchronous: true
            fillMode: Image.PreserveAspectFit
            source: exDivider.iconSource
            sourceSize: exDivider.iconSize
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredWidth: exDivider.iconSize.width
            Layout.preferredHeight: exDivider.iconSize.height
        }

        T.Label {
            id: content
            visible: (exDivider.type === ExDivider.DisplayType.Text && (!exDivider.onlyDisplayOneLine)) ? true : false
            text: qsTr(exDivider.text)
            color: exDivider.textColor
            font: exDivider.textFont
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        Rectangle {
            id: rightLine
            visible: !exDivider.onlyDisplayOneLine
            Layout.fillWidth: true
            Layout.preferredWidth: getLineWidth()
            Layout.preferredHeight: exDivider.lineHeight
            color: exDivider.rightLineColor

            function getLineWidth() {
                switch (exDivider.contentPosition) {
                case ExDivider.Position.Center:
                    return (exDivider.width - layout.curContent.width - 2 * exDivider.margin) / 2;
                case ExDivider.Position.Right:
                case ExDivider.Position.Left:
                    return exDivider.width - layout.curContent.width - leftLine.width - 2 * exDivider.margin;
                }
            }
        }
    }
}
