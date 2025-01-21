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
    
    var fetchAnswerListOfProfile: (_ threshold: Int?) async throws -> ([AnswerOfProfile], QappleAPI.PaginationInfo)
    var deleteAnswer: (_ answerId: Int) async throws -> DeleteAnswerDTO
    var fetchAnswerListOfQuestion: (_ questionId: Int, _ threshold: Int?) async throws -> ([AnswerOfQuestion], QappleAPI.PaginationInfo)
    var postAnswer: (_ questionId: Int, _ answer: String) async throws -> PostAnswerDTO
    
    var fetchBulletinBoard: (_ threshold: Int?) async throws -> ([BulletinBoard], QappleAPI.PaginationInfo)
    var postBoard: (_ content: String) async throws -> PostBoardDTO
    var fetchSingleBoard: (_ boardId: Int) async throws -> BulletinBoard
    var deleteBoard: (_ boardId: Int) async throws -> DeleteBoardDTO
    var likeBoard: (_ boardId: Int) async throws -> LikeBoardDTO
    var searchBoard: (_ keyword: String?, _ threshold: Int?) async throws -> ([BulletinBoard], QappleAPI.PaginationInfo)
    
    var fetchQuestionList: (_ threshold: String?) async throws -> ([Question], QappleAPI.PaginationInfo)
    var fetchMainQuestionList: () async throws -> QuestionOfMain
    
    var fetchNotificationList: (_ threshold: Int?) async throws -> ([QappleNotification], QappleAPI.PaginationInfo)
    
    var reportsBoard: (_ boardId: Int, _ boardReportType: String) async throws -> BoardReportsDTO
    var reportsBoardComment: (_ boardCommentId: Int, _ boardCommentReportType: String) async throws -> BoardCommentReportsDTO
    var reportsAnswer: (_ answerId: Int, _ reportType: String) async throws -> AnswerReportsDTO
    
    var refreshToken: () async throws -> RefreshToken
}

extension QappleRepository: DependencyKey {
    
    static let liveValue = Self (
        fetchAnswerListOfProfile: makeFetchAnswerListOfProfile(),
        deleteAnswer: makeDeleteAnswer(),
        fetchAnswerListOfQuestion: makeFetchAnswerListOfQuestion(),
        postAnswer: makePostAnswer(),
        
        fetchBulletinBoard: makeFetchBulletinBoard(),
        postBoard: makePostBoard(),
        fetchSingleBoard: makeFetchSingleBoard(),
        deleteBoard: makeDeleteBoard(),
        likeBoard: makeLikeBoard(),
        searchBoard: makeSearchBoard(),
        
        fetchQuestionList: makeFetchQuestionList(),
        fetchMainQuestionList: makeFetchMainQuestionList(),
        
        fetchNotificationList: makeFetchNotificationList(),
        
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
