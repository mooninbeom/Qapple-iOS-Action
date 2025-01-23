//
//  QuestionKey.swift
//  Qapple
//
//  Created by Simmons on 1/21/25.
//

import Foundation

extension QappleRepository {
    
    /// 모든 질문 조회
    static func makeFetchQuestionList() -> (_ threshold: String?) async throws -> ([QuestionEntity], QappleAPI.TotalCount, QappleAPI.PaginationInfo) {
        return { threshold in
            let url = try QappleAPI.Question.list(threshold: threshold, pageSize: 25).url()
            let response: BaseResponse<QuestionsDTO> = try await networkClient.get(url: url)
            return response.result.toEntityWithInfo
        }
    }
    
    /// 메인 질문 조회
    static func makeFetchMainQuestionList() -> () async throws -> QuestionEntity {
        return {
            let url = try QappleAPI.Question.listOfMain.url()
            let response: BaseResponse<MainQuestionDTO> = try await networkClient.get(url: url)
            return response.result.toEntity
        }
    }
}
