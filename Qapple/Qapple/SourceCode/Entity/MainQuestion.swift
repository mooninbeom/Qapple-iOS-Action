//
//  MainQuestion.swift
//  Qapple
//
//  Created by Simmons on 1/21/25.
//

import Foundation

struct MainQuestion: Identifiable, Equatable {
    let id: Int
    let title: String
    var isAnswered: Bool
}
