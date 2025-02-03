//
//  AnswersOfProfileDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct AnswersOfProfileDTO: Codable {
    let total: Int?
    let size: Int
    let content: [Content]
    let numberOfElements: Int
    let threshold: String
    let hasNext: Bool
    
    struct Content: Codable, Hashable {
        let questionId: Int
        let answerId: Int
        let writerId: Int
        let nickname: String
        let profileImage: String?
        let content: String
        let heartCount: Int
        let writeAt: String
        let isLiked: Bool
    }
    
    var toEntityWithThreshold: ([AnswerOfProfile], QappleAPI.PaginationInfo) {
        let answerListOfProfile = self.content.map {
            AnswerOfProfile(
                id: $0.questionId,
                answerId: $0.answerId,
                writerId: $0.writerId,
                nickname: $0.nickname,
                content: $0.content,
                writeAt: $0.writeAt.ISO8601ToDate
            )
        }
        
        let paginationInfo = QappleAPI.PaginationInfo(
            threshold: self.threshold,
            hasNext: self.hasNext
        )
        
        return (answerListOfProfile, paginationInfo)
    }
}
