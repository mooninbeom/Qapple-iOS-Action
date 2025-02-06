//
//  LikeBoardCommentsDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct LikeBoardCommentsDTO: Codable {
    let boardCommentId: Int
    let isLiked: Bool
}

struct LikeBoardCommentsRequest: Codable {
    let commentId: Int
}
