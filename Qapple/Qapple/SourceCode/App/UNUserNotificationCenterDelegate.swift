//
//  UNUserNotificationCenterDelegate.swift
//  Qapple
//
//  Created by 김민준 on 2/21/25.
//

import UIKit

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /// 푸시 메세지가 앱이 켜져있을 때 나올 때
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
        -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        pushNotificationTapped(userInfo: userInfo)
        
        // Do Something With MSG Data...
        if let messageID = userInfo[Constant.gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler([[.banner, .badge, .sound]])
    }
    
    /// 푸시메세지를 받았을 때
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        pushNotificationTapped(userInfo: userInfo)
        
        // Do Something With MSG Data...
        if let messageID = userInfo[Constant.gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler()
    }
    
    private func pushNotificationTapped(userInfo: [AnyHashable: Any]) {
        if let questionId = userInfo["questionId"],
           let idString = questionId as? String,
           let _ = Int(idString) {
            // TODO: API 업데이트 후 추후 적용
            //            evaluateQuestionPushNotification(id)
        }
        
        if let boardId = userInfo["boardId"],
           let idString = boardId as? String,
           let id = Int(idString) {
            Task {
                do {
                    let response = try await bulletinBoardRepository.fetchSingleBoard(id)
                    mainFlowStore.send(.pushToComment(response))
                } catch {
                    print("Failed to fetch single board")
                }
            }
        }
    }
    
    private func evaluateQuestionPushNotification(_ id: Int) {
        var hasNext = true
        var threshold: String?
        while hasNext {
            Task {
                let response = try await questionRepository.fetchQuestionList(threshold)
                response.0.forEach {
                    if $0.id == id {
                        if $0.isAnswered {
                            mainFlowStore.send(.pushToAnswerList($0))
                        } else {
                            mainFlowStore.send(.pushToWriteAnswer($0))
                        }
                        return
                    }
                }
                threshold = response.2.threshold
                hasNext = response.2.hasNext
            }
        }
    }
}
