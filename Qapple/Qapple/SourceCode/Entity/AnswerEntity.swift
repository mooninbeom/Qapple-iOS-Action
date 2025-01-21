//
//  Answer.swift
//  Qapple
//
//  Created by 김민준 on 1/21/25.
//

import Foundation

/// 현재 Legacy 코드와의 충돌을 염두에 두어 Entity를 접미에 붙여 네이밍했습니다.
/// 추후 Answer로 변경 예정입니다!
struct AnswerEntity: Identifiable, Equatable {
    
    /// 답변 ID
    let id: Int
    
    /// 답변 내용
    let content: String
    
    /// 답변 게시 날짜
    let publishedDate: Date
    
    /// 답변 신고 여부
    let isReported: Bool
    
    /// 현재 사용자가 작성한 답변인지 여부
    let isMine: Bool
}
