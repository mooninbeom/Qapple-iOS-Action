//
//  NotificationsDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct NotificationsDTO: Codable {
    let total: Int?
    let size: Int
    let content: [Content]
    let numberOfElements: Int
    let threshold: String
    let hasNext: Bool
    
    struct Content: Codable {
        let title: String
        let subtitle: String?
        let content: String?
        let boardId: String?
        let questionId: String?
        let boardCommentId: String?
        let createdAt: String
    }
    
    var toEntityWithThreshold: ([QappleNotification], QappleAPI.PaginationInfo) {
        let qappleNotificationList = self.content.map {
            QappleNotification(
                id: $0.questionId ?? "",
                boardId: $0.boardId ?? "",
                boardCommentId: $0.boardCommentId,
                title: $0.title,
                subtitle: $0.subtitle,
                content: $0.content ?? "",
                createAt: $0.createdAt.ISO8601ToDate,
                isReadStatus: false
            )
        }
        return (qappleNotificationList, (threshold, hasNext))
    }
}
