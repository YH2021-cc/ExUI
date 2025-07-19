import QtQuick
import QtQuick.Controls as T
import QtQuick.Layouts
import "./"

ExBaseButton {
    id: button

    //图标是否缓存
    property bool cache: true
    //图标源
    property url source
    //图标大小
    property size sourceSize: Qt.size(16, 16)
    //图标填充模式
    property int fillMode: Image.PreserveAspectFit

    //文本颜色
    property color textColor: "white"
    //文本字体
    property font textFont: Qt.font({
        pixelSize: 16
    })
    //文本内容
    property string text: "普通按钮"
    //长文本显示
    property int elide

    //行间距
    property int rowSpacing: 5
    //列间距
    property int columnSpacing: 5

    //按钮的显示方式
    property int display: ExButton.DisplayMode.TextToIcon

    enum DisplayMode {
        IconOnly, //仅显示图标
        TextOnly,//仅显示文本
        TextToIcon,//文本在图标左侧
        IconTotext,//图标在文本左侧
        TextUnderIcon//图标在文本上方,此时图标大小应大一些更合适
    }

    implicitWidth: 100
    implicitHeight: 30

    GridLayout {
        id: buttonLayout
        anchors.centerIn: parent
        Layout.fillHeight: true
        Layout.fillWidth: true
        rowSpacing: button.rowSpacing
        columnSpacing: button.columnSpacing
        flow: button.display === ExButton.DisplayMode.TextUnderIcon ? GridLayout.TopToBottom : GridLayout.LeftToRight
        layoutDirection: button.display === ExButton.DisplayMode.TextToIcon ? Qt.RightToLeft : Qt.LeftToRight

        Image {
            id: icon
            visible: button.display === ExButton.DisplayMode.TextOnly ? false : true
            asynchronous: true
            fillMode: button.fillMode
            source: button.source
            sourceSize: button.sourceSize
            cache: button.cache
        }

        T.Label {
            id: buttonText
            visible: button.display === ExButton.DisplayMode.IconOnly ? false : true
            text: qsTr(button.text)
            font: button.textFont
            color: button.textColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            elide: button.elide
            clip: button.clip
        }
    }
}
