//
//  QuestionDTO.swift
//  Qapple
//
//  Created by Simmons on 1/21/25.
//

import Foundation

struct QuestionsDTO: Decodable {
    let total: Int
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
    
    var toEntityWithThreshold: ([Question], QappleAPI.PaginationInfo) {
        let questionList = self.content.map {
            Question(
                id: $0.questionId,
                title: $0.content,
                publishedDate: $0.livedAt,
                isAnswered: $0.isAnswered,
                isLived: false // questionStatus
            )
        }
        
        return (questionList, (threshold, hasNext))
    }
}
