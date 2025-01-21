//
//  QappleNoti.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct QappleNotification: Identifiable, Equatable {
    let id = UUID()
    let questionId: String
    let boardId: String
    let boardCommentId: String?
    let title: String
    let subtitle: String?
    let content: String
    let createAt: Date
    let isReadStatus: Bool // 확인한건지?
}
