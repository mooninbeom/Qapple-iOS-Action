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
        content.map {
            Answer(
                id: $0.answerId,
                content: $0.content,
                publishedDate: .now, // $0.writeAt
                isReported: $0.isReported
            )
        }
    }
}

