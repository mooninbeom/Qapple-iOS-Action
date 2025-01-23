//
//  AnswerReportsDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct AnswerReportsDTO: Codable {
    let reportId: Int
}

struct AnswerReportsRequest: Codable {
//    let questionId: Int
    let answerId: Int
    let reportType: String
}
