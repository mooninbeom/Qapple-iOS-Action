//
//  BoardReportsDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct BoardReportsDTO: Codable {
    let boardId: Int
    let boardReportType: String
}

struct BoardReportsRequest: Codable {
    let boardId: Int
    let boardReportType: String
}
