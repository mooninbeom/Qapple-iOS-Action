//
//  AnswerKey.swift
//  Qapple
//
//  Created by Simmons on 1/21/25.
//

import Foundation

extension QappleRepository {
    
    /// (자신의) 작성한 답변 조회
    static func makeFetchAnswerListOfProfile() -> (_ threshold: Int?) async throws -> ([AnswerOfProfile], QappleAPI.PaginationInfo) {
        return { threshold in
            let url = try QappleAPI.Answer.listOfProfile(threshold: threshold, pageSize: 25).url()
            let response: BaseResponse<AnswersOfProfileDTO> = try await networkClient.get(url: url)
            return response.result.toEntityWithThreshold
        }
    }
    
    /// 답변 삭제
    static func makeDeleteAnswer() -> (_ answerId: Int) async throws -> DeleteAnswerDTO {
        return { answerId in
            let url = try QappleAPI.Answer.delete(answerId: answerId).url()
            let response: BaseResponse<DeleteAnswerDTO> = try await networkClient.delete(url: url)
            return response.result
        }
    }
    
    /// 질문에 대한 답변 조회
    static func makeFetchAnswerListOfQuestion() -> (_ questionId: Int, _ threshold: Int?) async throws -> ([AnswerOfQuestion], QappleAPI.PaginationInfo) {
        return { questionId, threshold in
            let url = try QappleAPI.Answer.listOfQuestion(questionId: Int(questionId), threshold: String(threshold ?? 0), pageSize: 25).url()
            let response: BaseResponse<AnswersOfQuestionDTO> = try await networkClient.get(url: url)
            return ([], .init(threshold: "", hasNext: false))
        }
    }
    
    /// 답변 생성
    static func makePostAnswer() -> (_ questionId: Int, _ answer: String) async throws -> PostAnswerDTO {
        return { questionId, answer in
            let url = try QappleAPI.Answer.post(questionId: questionId).url()
            let requestBody: PostAnswerRequest = PostAnswerRequest(answer: answer)
            let response: BaseResponse<PostAnswerDTO> = try await networkClient.post(url: url, body: requestBody)
            return response.result
        }
    }
}
