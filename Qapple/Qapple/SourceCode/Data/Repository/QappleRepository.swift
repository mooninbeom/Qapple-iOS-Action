//
//  QappleRepository.swift
//  Qapple
//
//  Created by Simmons on 1/21/25.
//

import Foundation
import ComposableArchitecture

struct QappleRepository {
    static let networkClient = NetworkClient()
    
    var fetchQuestionList: (_ threshold: String?) async throws -> ([Question], QappleAPI.PaginationInfo)
    var fetchMainQuestionList: () async throws -> QuestionOfMain
    
    var fetchAnswerListOfProfile: (_ threshold: Int?) async throws -> ([AnswerOfProfile], QappleAPI.PaginationInfo)
    var deleteAnswer: (_ answerId: Int) async throws -> DeleteAnswerDTO
    var fetchAnswerListOfQuestion: (_ questionId: Int, _ threshold: Int?) async throws -> ([AnswerOfQuestion], QappleAPI.PaginationInfo)
    var registerAnswer: (_ questionId: Int, _ answer: String) async throws -> RegisterAnswerDTO
    
    var qappleNotificationList: (_ threshold: Int?) async throws -> ([QappleNotification], QappleAPI.PaginationInfo)
    
    var reportsBoard: (_ boardId: Int, _ boardReportType: String) async throws -> BoardReportsDTO
    var reportsBoardComment: (_ boardCommentId: Int, _ boardCommentReportType: String) async throws -> BoardCommentReportsDTO
    var reportsAnswer: (_ answerId: Int, _ reportType: String) async throws -> AnswerReportsDTO
    
    var refreshToken: () async throws -> RefreshToken
}

extension QappleRepository: DependencyKey {
    
    static let liveValue = Self (
        fetchQuestionList: makeFetchQuestionList(),
        fetchMainQuestionList: makeFetchMainQuestionList(),
        
        fetchAnswerListOfProfile: makeFetchAnswerListOfProfile(),
        deleteAnswer: makeDeleteAnswer(),
        fetchAnswerListOfQuestion: makeFetchAnswerListOfQuestion(),
        registerAnswer: makeRegisterAnswer(),
        
        qappleNotificationList: makeNotification(),
        
        reportsBoard: makeReportsBoard(),
        reportsBoardComment: makeReportsBoardComment(),
        reportsAnswer: makeReportsAnswer(),
        
        refreshToken: makeRefreshToken()
    )
}

extension DependencyValues {
    var qappleRepository: QappleRepository {
        get { self[QappleRepository.self] }
        set { self[QappleRepository.self] = newValue }
    }
}
