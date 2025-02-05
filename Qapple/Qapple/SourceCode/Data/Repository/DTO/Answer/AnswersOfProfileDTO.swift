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
    
    var toEntityWithThreshold: ([Answer], QappleAPI.PaginationInfo) {
        let answerListOfProfile = self.content.map {
            Answer(
                id: $0.answerId,
                content: $0.content,
                authorNickname: $0.nickname,
                publishedDate: $0.writeAt.ISO8601ToDate,
                isReported: false,
                isMine: true,
                isResignMember: false
            )
        }
        
        let paginationInfo = QappleAPI.PaginationInfo(
            threshold: self.threshold,
            hasNext: self.hasNext
        )
        
        return (answerListOfProfile, paginationInfo)
    }
}
