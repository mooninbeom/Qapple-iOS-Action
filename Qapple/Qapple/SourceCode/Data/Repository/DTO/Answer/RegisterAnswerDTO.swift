//
//  RegisterAnswerDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct RegisterAnswerDTO: Codable {
    let answerId: Int
}

struct RegisterAnswerRequest: Codable {
    let answer: String
}
