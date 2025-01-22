//
//  MainQuestionDTO.swift
//  Qapple
//
//  Created by Simmons on 1/21/25.
//

import Foundation

struct MainQuestionDTO: Codable {
    let questionId: Int
    let questionStatus: String
    let content: String
    let isAnswered: Bool
    
    var toEntity: QuestionOfMain {
        return QuestionOfMain(
            id: questionId,
            title: content,
            isAnswered: isAnswered
        )
    }
}
