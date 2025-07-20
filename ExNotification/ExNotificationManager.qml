import QtQuick

// 通知管理器 - 负责管理所有通知的显示和排列
Item {
    id: notificationManager
    anchors.fill: parent  // 填充整个父容器

    // 通知队列 - 存储当前显示的所有通知对象(可通过它获取到通知对象并设置属性)
    property var notificationQueue: []

    // 添加新通知的函数

    function showNotification(type, title, message, width = 340, height = 90, showIcon = true, showClose = true, titleTextColor = "black", contentTextColor = "black") {
        var notificationComponent = Qt.createComponent("ExNotification.qml");
        if (notificationComponent.status === Component.Ready) {
            var notification = notificationComponent.createObject(notificationManager, {
                "type": type,
                "titleText": title,
                "contentText": message,
                "width": width,
                "height": height,
                "showIcon": showIcon,
                "showClose": showClose,
                "titleTextColor": titleTextColor,
                "contentTextColor": contentTextColor,
                "index": notificationQueue.length  // 设置通知在队列中的索引
            });

            // 连接通知的关闭信号到移除函数
            notification.closed.connect(function () {
                removeNotification(notification);
            });
            // 将新通知添加到队列中
            notificationQueue.push(notification);
            // 重新排列所有通知的位置
            arrangeNotifications();
        } else
            console.error(notificationComponent.status);
    }

    // 移除通知的函数
    // @param notification: 要移除的通知对象
    function removeNotification(notification) {
        // 在队列中查找通知的索引
        var index = notificationQueue.indexOf(notification);
        if (index !== -1) {
            // 从队列中移除通知
            notificationQueue.splice(index, 1);
            // 重新排列剩余通知的位置
            arrangeNotifications();
            // 延迟销毁通知对象，等待关闭动画完成
            notification.destroy(notification.closeTimeout);
        }
    }

    // 重新排列通知位置的函数
    function arrangeNotifications() {
        var verticalSpacing = 10;  // 通知之间的垂直间距
        var verticalPos = 20;      // 第一个通知的垂直位置

        // 遍历所有通知，重新计算它们的位置
        for (var i = 0; i < notificationQueue.length; i++) {
            var notif = notificationQueue[i];
            notif.newPosition = verticalPos;  // 设置新位置
            verticalPos += notif.height + verticalSpacing;  // 计算下一个通知的位置

            // 更新通知在队列中的索引（用于动画效果）
            notif.index = i;
            notif.open();
        }
    }
}
