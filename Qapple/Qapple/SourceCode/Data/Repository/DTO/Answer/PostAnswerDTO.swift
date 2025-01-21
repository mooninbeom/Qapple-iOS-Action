//
//  RegisterAnswerDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct PostAnswerDTO: Codable {
    let answerId: Int
}

struct PostAnswerRequest: Codable {
    let answer: String
}
