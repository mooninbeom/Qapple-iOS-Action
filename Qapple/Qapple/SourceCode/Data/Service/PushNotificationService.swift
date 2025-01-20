//
//  Notification.swift
//  Capple
//
//  Created by 김민준 on 3/21/24.
//

import UserNotifications

final class PushNotificationService: ObservableObject {
    
    static let shared = PushNotificationService()
    private init() {}
    
    @Published var boardId: Int?
    @Published var questionId: Int?
    
    /// Notification 권한을 요청합니다.
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { didAllow,Error in
            if didAllow {
                print("Push: 권한 허용")
            } else {
                print("Push: 권한 거부")
            }
        })
    }
}
