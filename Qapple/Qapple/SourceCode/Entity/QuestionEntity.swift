//
//  Question.swift
//  Qapple
//
//  Created by 김민준 on 1/21/25.
//

import Foundation

/// 현재 Legacy 코드와의 충돌을 염두에 두어 Entity를 접미에 붙여 네이밍했습니다.
/// 추후 Question로 변경 예정입니다!
struct QuestionEntity: Identifiable, Equatable {
    
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
    static var initialState: QuestionEntity {
        QuestionEntity(
            id: 0,
            content: "",
            publishedDate: .now,
            isAnswered: false,
            isLived: false
        )
    }
}
