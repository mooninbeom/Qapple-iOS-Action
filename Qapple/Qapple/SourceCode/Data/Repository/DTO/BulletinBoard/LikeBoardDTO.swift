//
//  LikeBoardDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct LikeBoardDTO: Codable {
    let boardId: Int
    let isLiked: Bool
}

struct LikeBoardRequest: Codable {
    let boardId: Int
}
