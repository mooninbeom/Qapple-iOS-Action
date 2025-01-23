//
//  BoardComment.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct BoardComment: Identifiable, Equatable {
    let id: Int
    let writeId: Int
    let content: String
    let heartCount: Int
    let isLiked: Bool
    let isMine: Bool
    let isReport: Bool
    let createdAt: String
}
