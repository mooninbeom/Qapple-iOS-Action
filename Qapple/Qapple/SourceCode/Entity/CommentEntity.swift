//
//  CommentEntity.swift
//  Qapple
//
//  Created by 문인범 on 1/21/25.
//

import Foundation



struct CommentEntity: Identifiable, Equatable {
    var id: Int
    var writerId: Int
    var content: String
    var createdAt: String
    var heartCount: Int
    
    var isLiked: Bool
    var isMine: Bool
    var isReport: Bool
}
