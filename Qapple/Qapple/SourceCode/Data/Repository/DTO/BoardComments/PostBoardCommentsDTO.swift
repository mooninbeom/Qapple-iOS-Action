//
//  PostBoardCommentsDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct PostBoardCommentsDTO: Codable {
    let boardCommentId: Int
}

struct PostBoardCommentsRequest: Codable {
    let comment: String
}
