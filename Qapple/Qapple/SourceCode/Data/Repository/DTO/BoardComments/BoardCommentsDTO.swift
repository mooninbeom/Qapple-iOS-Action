//
//  BoardCommentsDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct BoardCommentsDTO: Codable {
    let total: Int?
    let size: Int
    let content: [Comment]
    let numberOfElements: Int
    let threshold: String
    let hasNext: Bool
    
    struct Comment: Codable {
        let boardCommentId: Int
        let writerId: Int
        let content: String
        let heartCount: Int
        let isLiked: Bool
        let isMine: Bool
        let isReport: Bool
        let CreatedAt: String
    }
    
    var toEntityWithThreshold: ([BoardComment], QappleAPI.PaginationInfo) {
        let boardCommentList = self.content.map {
            BoardComment(
                id: $0.boardCommentId,
                writeId: $0.writerId,
                content: $0.content,
                heartCount: $0.heartCount,
                isLiked: $0.isLiked,
                isMine: $0.isMine,
                isReport: $0.isReport,
                createdAt: $0.CreatedAt,
                anonymityId: -2
            )
        }
        
        let paginationInfo = QappleAPI.PaginationInfo(
            threshold: self.threshold,
            hasNext: self.hasNext
        )
        
        return (boardCommentList, paginationInfo)
    }
}
