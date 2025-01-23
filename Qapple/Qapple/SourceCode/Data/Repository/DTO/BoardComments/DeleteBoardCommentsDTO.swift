//
//  DeleteBoardCommentsDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct DeleteBoardCommentsDTO: Codable {
    let boardCommentId: Int
}

struct DeleteBoardCommentsRequest: Codable {
    let boardCommentId: Int
}
