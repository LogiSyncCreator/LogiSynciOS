//
//  TestLocalNotification.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/07/05.
//

import Foundation
import UserNotifications

final class TestLocalNotification {
    
    func createNotificationContent(_ body: String = "この通知は見えていないはずだよ！") -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "テスト用"
        content.body = body
        content.sound = UNNotificationSound.default
        return content
    }
    
    func createTrigger() -> UNNotificationTrigger {
        // 例えば5秒後に通知を表示するトリガー
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        return trigger
    }
    
    func scheduleNotification(_ body: String = "この通知は見えていないはずだよ！") {
        let content = createNotificationContent(body)
        let trigger = createTrigger()
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知のスケジュールに失敗しました: \(error.localizedDescription)")
            }
        }
    }
    
}
