//
//  QuestionKey.swift
//  Qapple
//
//  Created by Simmons on 1/21/25.
//

import Foundation

extension QappleRepository {
    static func makeFetchQuestionList() -> (_ threshold: String?) async throws -> ([Question], QappleAPI.PaginationInfo) {
        return { threshold in
            let url = try QappleAPI.Question.list(threshold: threshold, pageSize: 10).url()
            let response: BaseResponse<QuestionsDTO> = try await networkClient.get(url: url)
            return response.result.toEntityWithThreshold
        }
    }
}


