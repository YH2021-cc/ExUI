//RoundProGressBar.qml
import QtQuick

Item {
    id: root
    // ===== 公开属性声明 =====
    // 进度值，范围0-100
    property real value: 0
    // 进度条的粗细程度
    property real thickness: 10
    // 进度圆环的颜色，默认为绿色
    property color progressColor: "#4CAF50"
    // 背景圆环的颜色，默认为浅灰色
    property color backgroundColor: "#E0E0E0"
    // ===== 私有属性声明 =====
    // 计算圆的半径（取宽高中的较小值的一半）
    property real _radius: Math.min(width, height) / 2
    // 计算圆心的X坐标（宽度的一半）
    property real _centerX: width / 2
    // 计算圆心的Y坐标（高度的一半）
    property real _centerY: height / 2
    // ===== 背景圆环 =====
    Canvas {
        // 填充父元素的所有可用空间
        anchors.fill: parent
        // 当需要重绘时调用此函数
        onPaint: {
            // 获取2D绘图上下文
            var ctx = getContext("2d");
            // 重置当前的绘图状态
            ctx.reset();
            // 开始一个新的绘图路径
            ctx.beginPath();
            // 绘制完整的背景圆环
            // 参数：圆心x，圆心y，半径，起始角度，结束角度，是否逆时针
            ctx.arc(root._centerX, root._centerY, root._radius - root.thickness / 2, 135 * Math.PI / 180, 45 * Math.PI / 180, false);
            // 设置线条宽度
            ctx.lineWidth = root.thickness;
            // 设置描边颜色
            ctx.strokeStyle = root.backgroundColor;
            // 执行描边操作
            ctx.stroke();
        }
    }
    // ===== 进度圆环 =====
    Canvas {
        // 填充父元素的所有可用空间
        anchors.fill: parent
        // 当需要重绘时调用此函数
        onPaint: {
            // 获取2D绘图上下文
            var ctx = getContext("2d");
            // 重置当前的绘图状态
            ctx.reset();
            // 设置起始角度为135度
            var startAngle = 135 * Math.PI / 180;
            // 计算结束角度（根据当前进度值）
            // 当value为1时,实际显示的进度为1%的圆弧
            // 例如: 1 / 100 = 0.01,表示转了0.01圈
            var endAngle = startAngle + (270 * Math.PI / 180 * (root.value / 100));
            // 开始一个新的绘图路径
            ctx.beginPath();
            // 绘制进度圆弧
            ctx.arc(root._centerX, root._centerY, root._radius - root.thickness / 2, startAngle, endAngle, false);
            // 设置线条宽度
            ctx.lineWidth = root.thickness;
            // 设置描边颜色
            ctx.strokeStyle = root.progressColor;
            // 设置线条端点为圆形
            ctx.lineCap = "round";
            // 绘制进度圆弧
            ctx.stroke();
        }
    }
    // 当进度值改变时触发重绘
    onValueChanged: {
        if (root.value <= 100)
            requestPaint();
    }
    // 请求重绘所有Canvas子元素的函数
    function requestPaint() {
        // 遍历所有子元素
        for (var i = 0; i < children.length; ++i) {
            // 如果子元素是Canvas类型
            if (children[i] instanceof Canvas) {
                // 请求重绘该Canvas
                children[i].requestPaint();
            }
        }
    }
}
