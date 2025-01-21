//
//  Question.swift
//  Qapple
//
//  Created by Simmons on 1/21/25.
//

import Foundation

struct Question: Identifiable, Equatable {
    let id: Int
    let title: String
    let publishedDate: Date
    var isAnswered: Bool
    var isLived: Bool
}
