//
//  TestLocalNotification.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/07/05.
//

import Foundation
import UserNotifications

final class TestLocalNotification {
    
    func createNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "テスト用"
        content.body = "この通知は見えていないはずだよ！"
        content.sound = UNNotificationSound.default
        return content
    }
    
    func createTrigger() -> UNNotificationTrigger {
        // 例えば5秒後に通知を表示するトリガー
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        return trigger
    }
    
    func scheduleNotification() {
        let content = createNotificationContent()
        let trigger = createTrigger()
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知のスケジュールに失敗しました: \(error.localizedDescription)")
            }
        }
    }
    
}
