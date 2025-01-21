//
//  AnswerKey.swift
//  Qapple
//
//  Created by Simmons on 1/21/25.
//

import Foundation

extension QappleRepository {
    static func makeFetchAnswerList() -> (_ questionId: Int, _ threshold: String?) async throws -> ([Answer2]) {
        return { questionId, threshold in
            let url = try QappleAPI.Answer.listOfQuestion(
                questionId: Int64(questionId),
                threshold: threshold,
                pageSize: 10).url()
            let response: BaseResponse<AnswersOfQuestionDTO> = try await networkClient.get(url: url)
            return response.result.toEntity
        }
    }
}
