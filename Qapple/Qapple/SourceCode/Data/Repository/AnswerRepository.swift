//
//  AnswerRepository.swift
//  Qapple
//
//  Created by 김민준 on 1/23/25.
//

import ComposableArchitecture
import Foundation

struct AnswerRepository {
    var fetchAnswerPreviewList: (_ questionId: Int) async throws -> [AnswerEntity]
    var fetchAnswerListOfQuestion: (_ questionId: Int, _ threshold: Int?) async throws -> (
        [AnswerEntity],
        QappleAPI.TotalCount,
        QappleAPI.PaginationInfo
    )
}

// MARK: - DependencyKey

extension AnswerRepository: DependencyKey {
    
    private static let networkService = NetworkService()
    
    static let liveValue = Self(
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
                questionId: Int(questionId),
                threshold: threshold,
                pageSize: 25
            ).url()
            
            let response: BaseResponse<AnswersOfQuestionDTO> = try await networkService.get(url: url)
            return response.result.toEntityWithInfo
        }
    )
    
    static let previewValue = Self(
        fetchAnswerPreviewList: { questionId in
            stubAnswerList.dropLast(22)
        },
        fetchAnswerListOfQuestion: { _, _ in
            (stubAnswerList, 25, .init(threshold: "", hasNext: false))
        }
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
    
    private static var stubAnswerList: [AnswerEntity] {
        var answerList: [AnswerEntity] = []
        for i in 0..<25 {
            answerList.append(
                AnswerEntity(
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
