//
//  AnswerRepository.swift
//  Qapple
//
//  Created by 김민준 on 1/23/25.
//

import ComposableArchitecture
import Foundation

struct AnswerRepository {
    var fetchAnswerListOfProfile: (_ threshold: Int?) async throws -> ([AnswerOfProfile], QappleAPI.PaginationInfo)
    var fetchAnswerPreviewList: (_ questionId: Int) async throws -> [Answer]
    var fetchAnswerListOfQuestion: (_ questionId: Int, _ threshold: String?) async throws -> (
        [Answer],
        QappleAPI.TotalCount,
        QappleAPI.PaginationInfo
    )
    var postAnswer: (_ questionId: Int, _ answer: String) async throws -> Void
    var deleteAnswer: (_ answerId: Int) async throws -> Void
}

// MARK: - DependencyKey

extension AnswerRepository: DependencyKey {
    private static let networkService = NetworkService.shared
    
    static let liveValue = Self(
        fetchAnswerListOfProfile: { threshold in
            let url = try QappleAPI.Answer.listOfProfile(threshold: threshold, pageSize: 25).url()
            let response: BaseResponse<AnswersOfProfileDTO> = try await NetworkService.shared.get(url: url)
            return response.result.toEntityWithThreshold
        },
        fetchAnswerPreviewList: { questionId in
            let url = try QappleAPI.Answer.listOfQuestion(
                questionId: Int(questionId),
                threshold: nil,
                pageSize: 3
            ).url()
            
            let response: BaseResponse<AnswersOfQuestionDTO> = try await networkService.get(url: url)
            return response.result.toEntity
        },
        fetchAnswerListOfQuestion: { questionId, threshold in
            let url = try QappleAPI.Answer.listOfQuestion(
                questionId: questionId,
                threshold: threshold,
                pageSize: 25
            ).url()
            
            let response: BaseResponse<AnswersOfQuestionDTO> = try await networkService.get(url: url)
            return response.result.toEntityWithInfo
        },
        postAnswer: { questionId, answer in
            let url = try QappleAPI.Answer.post(questionId: questionId).url()
            let requestBody = PostAnswerRequest(answer: answer)
            let response: BaseResponse<PostAnswerDTO> = try await networkService.post(url: url, body: requestBody)
            return ()
        },
        deleteAnswer: { answerId in
            let url = try QappleAPI.Answer.delete(answerId: answerId).url()
            let response: BaseResponse<DeleteAnswerDTO> = try await networkService.delete(url: url)
            return ()
        }
    )
    
    static let previewValue = Self(
        fetchAnswerListOfProfile: { _ in
            let stubProfiles = (0..<10).map { i in
                AnswerOfProfile(
                    id: i,
                    answerId: i,
                    writerId: i,
                    nickname: "러너 \(i)",
                    content: "테스트 답변 \(i)",
                    writeAt: "2025-01-23"
                )
            }
            return (stubProfiles, .init(threshold: "10", hasNext: false))
        },
        fetchAnswerPreviewList: { questionId in
            stubAnswerList.dropLast(22)
        },
        fetchAnswerListOfQuestion: { _, _ in
            (stubAnswerList, 25, .init(threshold: "", hasNext: false))
        },
        postAnswer: { _, _ in },
        deleteAnswer: { _ in }
    )
}

// MARK: - DependencyValues

extension DependencyValues {
    var answerRepository: AnswerRepository {
        get { self[AnswerRepository.self] }
        set { self[AnswerRepository.self] = newValue }
    }
}

// MARK: - Stub

extension AnswerRepository {
    
    private static var stubAnswerList: [Answer] {
        var answerList: [Answer] = []
        for i in 0..<25 {
            answerList.append(
                Answer(
                    id: i,
                    content: "테스트 답변 \(i)",
                    authorNickname: "\(i)번째 러너",
                    publishedDate: .init(timeIntervalSinceNow: TimeInterval(i*(-10000))),
                    isReported: i == 2,
                    isMine: i == 1,
                    isResignMember: i == 3
                )
            )
        }
        return answerList
    }
}
