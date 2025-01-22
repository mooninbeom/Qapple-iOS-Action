//
//  BoardCommentReportsDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct BoardCommentReportsDTO: Codable {
    let boardCommentId: Int
    let boardCommentReportType: String
}

struct BoardCommentReportsRequest: Codable {
    let boardCommentId: Int
    let boardCommentReportType: String
}
