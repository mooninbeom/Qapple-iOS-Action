//
//  Question.swift
//  Qapple
//
//  Created by 김민준 on 1/21/25.
//

import Foundation

struct Question: Identifiable, Equatable {
    
    /// 질문 ID
    let id: Int
    
    /// 질문 내용
    let content: String
    
    /// 질문 게시 날짜
    let publishedDate: Date
    
    /// 사용자가 질문에 답변했는지 여부
    var isAnswered: Bool
    
    /// 현재 LIVE 상태인지 여부
    var isLived: Bool
    
    /// 초기화용 질문 엔티티
    static var initialState: Question {
        Question(
            id: 0,
            content: "",
            publishedDate: .now,
            isAnswered: false,
            isLived: false
        )
    }
}
