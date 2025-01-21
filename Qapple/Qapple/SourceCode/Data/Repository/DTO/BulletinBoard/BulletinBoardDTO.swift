//
//  BulletinBoardDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct BulletinBoardDTO: Codable {
    let total: Int
    let size: Int
    let content: [content]
    let numberOfElements: Int
    let threshold: String
    let hasNext: Bool
    
    struct content: Codable {
        let boardId: Int
        let writerId: Int
        let writerNickname: String
        let content: String
        let heartCount: Int
        let commentCount: Int
        let createdAt: String
        let isMine: Bool
        let isReported: Bool
        let isLiked: Bool
        
        var toEntity: BulletinBoard {
            return BulletinBoard(
                boardId: boardId,
                writerId: writerId,
                writerNickname: writerNickname,
                content: content,
                heartCount: heartCount,
                commentCount: commentCount,
                createAt: createdAt.ISO8601ToDate,
                isMine: isMine,
                isReported: isReported,
                isLiked: isLiked
            )
        }
    }
    
    var toEntityWithThreshold: ([BulletinBoard], QappleAPI.PaginationInfo) {
        let bulletinBoardList = self.content.map {
            BulletinBoard(
                boardId: $0.boardId,
                writerId: $0.writerId,
                writerNickname: $0.writerNickname,
                content: $0.content,
                heartCount: $0.heartCount,
                commentCount: $0.commentCount,
                createAt: $0.createdAt.ISO8601ToDate,
                isMine: $0.isMine,
                isReported: $0.isReported,
                isLiked: $0.isLiked
            )
        }
        return (bulletinBoardList, (threshold, hasNext))
    }
    
    
}
