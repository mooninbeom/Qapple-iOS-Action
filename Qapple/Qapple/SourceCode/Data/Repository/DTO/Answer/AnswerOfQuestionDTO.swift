//
//  AnswerOfQuestionDTO.swift
//  Qapple
//
//  Created by Simmons on 1/21/25.
//

import Foundation

struct AnswersOfQuestionDTO: Codable {
    let total: Int
    let size: Int
    let content: [Content]
    let numberOfElements: Int
    let threshold: String
    let hasNext: Bool
    
    struct Content: Codable, Hashable {
        let answerId: Int
        let writerId: Int
        let profileImage: String?
        let nickname: String
        let content: String
        let isMine: Bool
        let isReported: Bool
        let isLiked: Bool
        let writeAt: String
    }
    
    var toEntity: [Answer] {
        self.content.map {
            Answer(
                id: $0.answerId,
                content: $0.content,
                authorNickname: $0.nickname,
                publishedDate: $0.writeAt.ISO8601ToDate,
                isReported: $0.isReported,
                isMine: $0.isMine,
                isResignMember: $0.nickname == "알 수 없음"
            )
        }
    }
    
    var toEntityWithInfo: ([Answer], QappleAPI.TotalCount, QappleAPI.PaginationInfo) {
        let answerList = self.content.map {
            Answer(
                id: $0.answerId,
                content: $0.content,
                authorNickname: $0.nickname,
                publishedDate: $0.writeAt.ISO8601ToDate,
                isReported: $0.isReported,
                isMine: $0.isMine,
                isResignMember: $0.nickname == "알 수 없음"
            )
        }
        
        let paginationInfo = QappleAPI.PaginationInfo(
            threshold: self.threshold,
            hasNext: self.hasNext
        )
        
        return(answerList, total, paginationInfo)
    }
}
