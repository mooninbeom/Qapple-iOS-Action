//
//  NewAnswer.swift
//  Qapple
//
//  Created by Simmons on 1/21/25.
//

import Foundation

struct AnswerOfQuestion: Identifiable, Equatable {
    let id: Int
    let content: String
    let publishedDate: Date
    let isReported: Bool
}
