//
//  PostBoardDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct PostBoardDTO: Codable {
    let boardId: Int
}

struct PostBoardRequest: Codable {
    let content: String
    let boardType: String
}
