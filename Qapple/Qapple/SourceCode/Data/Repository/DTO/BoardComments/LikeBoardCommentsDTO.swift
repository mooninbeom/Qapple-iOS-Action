//
//  LikeBoardCommentsDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct LikeBoardCommentsDTO: Codable {
    let boardCommentId: Int
    let isLike: Bool
}

struct LikeBoardCommentsRequest: Codable {
    let commentId: Int
}
