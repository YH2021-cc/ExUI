import QtQuick

// 消息提示管理器 - 负责管理所有消息提示的显示和排列
Item {
    id: messageManager
    anchors.fill: parent  // 填充整个父容器

    // 消息提示队列 - 存储当前显示的所有消息提示对象(可通过它获取到消息提示对象并设置属性)
    property var messageQueue: []

    // 添加新消息提示的函数

    function showMessage(type, text, width = 400, height = 40, textColor = "black", closeTimeout = 2000, center = false, showIcon = true, showClose = true) {
        var messageComponent = Qt.createComponent("ExMessage.qml");
        if (messageComponent.status === Component.Ready) {
            var message = messageComponent.createObject(messageManager, {
                "type": type,
                "text": text,
                "width": width,
                "height": height,
                "textColor": textColor,
                "closeTimeout": closeTimeout,
                "center": center,
                "showIcon": showIcon,
                "showClose": showClose,
                "index": messageQueue.length  // 设置消息提示在队列中的索引
            });

            // 连接消息提示的关闭信号到移除函数
            message.closed.connect(function () {
                removeMessage(message);
            });
            // 将新消息提示添加到队列中
            messageQueue.push(message);
            // 重新排列所有消息提示的位置
            arrangeMessages();
        } else
            console.error("showMessage error code:" + messageComponent.status);
    }

    // 移除消息提示的函数
    // @param message: 要移除的消息提示对象
    function removeMessage(message) {
        // 在队列中查找消息提示的索引
        var index = messageQueue.indexOf(message);
        if (index !== -1) {
            // 从队列中移除消息提示
            messageQueue.splice(index, 1);
            // 重新排列剩余消息提示的位置
            arrangeMessages();
            // 延迟销毁消息提示对象，等待关闭动画完成
            message.destroy(message.closeTimeout);
        }
    }

    // 重新排列消息提示位置的函数
    function arrangeMessages() {
        var verticalSpacing = 10;  // 消息提示之间的垂直间距
        var verticalPos = 20;      // 第一个消息提示的垂直位置

        // 遍历所有消息提示，重新计算它们的位置
        for (var i = 0; i < messageQueue.length; i++) {
            var msg = messageQueue[i];
            msg.newPosition = verticalPos;  // 设置新位置
            verticalPos += msg.height + verticalSpacing;  // 计算下一个消息提示的位置

            // 更新消息提示在队列中的索引（用于动画效果）
            msg.index = i;
            msg.open();
        }
    }
}
