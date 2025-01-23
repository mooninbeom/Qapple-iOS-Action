//
//  QuestionDTO.swift
//  Qapple
//
//  Created by Simmons on 1/21/25.
//

import Foundation

struct QuestionsDTO: Decodable {
    let total: QappleAPI.TotalCount
    let size: Int
    let content: [Content]
    let numberOfElements: Int
    let threshold: String
    let hasNext: Bool
    
    struct Content: Codable {
        var questionId: Int
        var questionStatus: String
        var livedAt: String?
        var content: String
        var isAnswered: Bool
    }
    
    var toEntityWithThreshold: ([QuestionEntity], QappleAPI.TotalCount, QappleAPI.PaginationInfo) {
        let questionList = self.content.map {
            QuestionEntity(
                id: $0.questionId,
                content: $0.content,
                publishedDate: $0.livedAt?.ISO8601ToDate ?? .now,
                isAnswered: $0.isAnswered,
                isLived: $0.questionStatus == "LIVE"
            )
        }
        
        let paginationInfo = QappleAPI.PaginationInfo(
            threshold: self.threshold,
            hasNext: self.hasNext
        )
        
        return (questionList, total, paginationInfo)
    }
}
