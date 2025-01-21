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
    var fetchMainQuestionList: () async throws -> MainQuestion
    var fetchAnswerList: (_ questionId: Int, _ threshold: String?) async throws -> ([Answer2])
}

extension QappleRepository: DependencyKey {
    
    static let liveValue = Self(
        fetchQuestionList: makeFetchQuestionList(),
        fetchMainQuestionList: makeFetchMainQuestionList(),
        
        fetchAnswerList: makeFetchAnswerList()
    )
}

extension DependencyValues {
    var qappleRepository: QappleRepository {
        get { self[QappleRepository.self] }
        set { self[QappleRepository.self] = newValue }
    }
}
