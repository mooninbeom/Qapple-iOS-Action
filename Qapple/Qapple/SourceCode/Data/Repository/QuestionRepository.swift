//
//  QuestionRepository.swift
//  Qapple
//
//  Created by 김민준 on 1/23/25.
//

import ComposableArchitecture
import Foundation

struct QuestionRepository {
    var fetchQuestionList: (_ threshold: String?) async throws -> ([QuestionEntity], QappleAPI.TotalCount, QappleAPI.PaginationInfo)
    var fetchMainQuestion: () async throws -> QuestionEntity
}

// MARK: - QuestionRepository

extension QuestionRepository: DependencyKey {
    
    private static let networkService = NetworkService()
    
    static let liveValue = Self(
        fetchQuestionList: { threshold in
            let url = try QappleAPI.Question.list(threshold: threshold, pageSize: 25).url()
            let response: BaseResponse<QuestionsDTO> = try await networkService.get(url: url)
            return response.result.toEntityWithThreshold
        },
        fetchMainQuestion: {
            let url = try QappleAPI.Question.listOfMain.url()
            let response: BaseResponse<MainQuestionDTO> = try await networkService.get(url: url)
            return response.result.toEntity
        }
    )
    
    static let previewValue = Self(
        fetchQuestionList: { threshold in
            (stubQuestionList, 25, QappleAPI.PaginationInfo(threshold: "", hasNext: false))
        },
        fetchMainQuestion: {
            QuestionEntity(
                id: 0,
                content: "프리뷰용 테스트 질문입니다.",
                publishedDate: .now,
                isAnswered: false,
                isLived: true
            )
        }
    )
}

// MARK: - DependencyValues

extension DependencyValues {
    var questionRepository: QuestionRepository {
        get { self[QuestionRepository.self] }
        set { self[QuestionRepository.self] = newValue }
    }
}

// MARK: - Stub

extension QuestionRepository {
    
    private static var stubQuestionList: [QuestionEntity] {
        var questionList: [QuestionEntity] = []
        for i in 0..<25 {
            questionList.append(
                QuestionEntity(
                    id: i,
                    content: "테스트 질문 \(i)",
                    publishedDate: .init(timeIntervalSinceNow: TimeInterval(i*10000)),
                    isAnswered: i % 2 == 1,
                    isLived: i == 0
                )
            )
        }
        return questionList
    }
}
