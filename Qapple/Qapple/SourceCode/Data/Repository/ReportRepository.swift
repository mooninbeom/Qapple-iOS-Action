//
//  ReportRepository.swift
//  Qapple
//
//  Created by 김민준 on 2/6/25.
//

import ComposableArchitecture
import Foundation

struct ReportRepository {
    var reportAnswer: (_ answerId: Int, _ reportType: ReportFeature.ReportType) async throws -> Void
    var reportBoard: (_ boardId: Int, _ reportType: ReportFeature.ReportType) async throws -> Void
    var reportComment: (_ commentId: Int, _ reportType: ReportFeature.ReportType) async throws -> Void
}

// MARK: - DependencyKey

extension ReportRepository: DependencyKey {
    
    static let liveValue = Self(
        reportAnswer: { answerId, reportType in
            let url = try QappleAPI.Reports.answer.url()
            let reportType = "QUESTION_" + reportType.rawValue
            let requestBody: AnswerReportsRequest = AnswerReportsRequest(answerId: answerId, reportType: reportType)
            let _: BaseResponse<AnswerReportsDTO> = try await NetworkService.shared.post(url: url, body: requestBody)
        },
        reportBoard: { boardId, reportType in
            let url = try QappleAPI.Reports.board.url()
            let reportType = "BOARD_" + reportType.rawValue
            let requestBody: BoardReportsRequest = .init(boardId: boardId, boardReportType: reportType)
            let _: BaseResponse<BoardReportsDTO> = try await NetworkService.shared.post(url: url, body: requestBody)
        },
        reportComment: { commentId, reportType in
            let url = try QappleAPI.Reports.boardComment.url()
            let reportType = "COMMENT_" + reportType.rawValue
            let requestBody: BoardCommentReportsRequest = .init(boardCommentId: commentId, boardCommentReportType: reportType)
            let _: BaseResponse<BoardCommentReportsDTO> = try await NetworkService.shared.post(url: url, body: requestBody)
        }
    )
}

// MARK: - DependencyValues

extension DependencyValues {
    var reportRepository: ReportRepository {
        get { self[ReportRepository.self] }
        set { self[ReportRepository.self] = newValue }
    }
}
