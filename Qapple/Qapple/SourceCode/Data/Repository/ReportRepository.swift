//
//  ReportRepository.swift
//  Qapple
//
//  Created by 김민준 on 2/6/25.
//

import ComposableArchitecture
import QappleRepository
import Foundation

struct ReportRepository {
    var reportAnswer: (_ answerId: Int, _ reportType: ReportType) async throws -> Void
    var reportBoard: (_ boardId: Int, _ reportType: ReportType) async throws -> Void
    var reportComment: (_ commentId: Int, _ reportType: ReportType) async throws -> Void
}

// MARK: - DependencyKey

extension ReportRepository: DependencyKey {
    
    @Dependency(\.keychainService) static var keychainService
    
    private static let repositoryService = RepositoryService.shared
    
    private static func accessToken() throws -> String {
        try keychainService.fetchData(.accessToken)
    }
    
    static let liveValue = Self(
        reportAnswer: { answerId, reportType in
            let _ = try await ReportAPI.reportAnswer(
                answerId: answerId,
                reportType: reportType,
                server: repositoryService.server,
                accessToken: accessToken()
            )
        },
        reportBoard: { boardId, reportType in
            let _ = try await ReportAPI.reportBoard(
                boardId: boardId,
                reportType: reportType,
                server: repositoryService.server,
                accessToken: accessToken()
            )
        },
        reportComment: { commentId, reportType in
            let _ = try await ReportAPI.reportBoardComment(
                boardCommentId: commentId,
                reportType: reportType,
                server: repositoryService.server,
                accessToken: accessToken()
            )
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
