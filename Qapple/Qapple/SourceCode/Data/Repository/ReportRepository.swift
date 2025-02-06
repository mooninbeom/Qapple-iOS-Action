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
}

// MARK: - DependencyKey

extension ReportRepository: DependencyKey {
    
    static let liveValue = Self(
        reportAnswer: { answerId, reportType in
            let url = try QappleAPI.Reports.answer.url()
            let reportType = "QUESTION_" + reportType.rawValue
            let requestBody: AnswerReportsRequest = AnswerReportsRequest(answerId: answerId, reportType: reportType)
            let _: BaseResponse<AnswerReportsDTO> = try await NetworkService.shared.post(url: url, body: requestBody)
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
