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
            let url = try QappleAPI.Question.allList(threshold: threshold, pageSize: 10).url()
            let response: BaseResponse<QuestionsDTO> = try await networkClient.get(url: url)
            return response.result.toEntityWithThreshold
        }
    }
    
    static func makeFetchMainQuestionList() -> () async throws -> MainQuestion {
        return {
            let url = try QappleAPI.Question.mainList.url()
            let response: BaseResponse<MainQuestionDTO> = try await networkClient.get(url: url)
            return response.result.toEntity
        }
    }
}


