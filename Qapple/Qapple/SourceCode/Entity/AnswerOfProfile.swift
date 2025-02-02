//
//  AnswerOfProfile.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct AnswerOfProfile: Identifiable, Equatable {
    let id: Int
    let answerId: Int
    let writerId: Int
    let nickname: String
    let content: String
    let writeAt: Date
}
