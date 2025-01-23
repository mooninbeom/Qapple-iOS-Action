//
//  QuestionListFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/22/25.
//

import ComposableArchitecture

@Reducer
struct QuestionListFeature {
    
    @ObservableState
    struct State: Equatable {
        var questionList: [QuestionEntity] = []
        var paginationInfo = QappleAPI.PaginationInfo(threshold: "", hasNext: false)
    }
    
    enum Action {
        case onAppear
        case refresh
        case pagination
        case questionListResponse([QuestionEntity], QappleAPI.PaginationInfo)
        case paginationResponse([QuestionEntity], QappleAPI.PaginationInfo)
        case questionCellTapped(QuestionEntity)
        case answerButtonTapped(QuestionEntity)
    }
    
    @Dependency(\.qappleRepository.fetchQuestionList) var fetchQuestionList
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear, .refresh:
                return .run { send in
                    do {
                        let response = try await fetchQuestionList(nil)
                        await send(.questionListResponse(response.0, response.1))
                    } catch {
                        print(error)
                    }
                }
                
            case .pagination:
                return .run { [threshold = state.paginationInfo.threshold] send in
                    do {
                        let response = try await fetchQuestionList(threshold)
                        await send(.paginationResponse(response.0, response.1))
                    } catch {
                        print(error)
                    }
                }
                
            case let .questionListResponse(questionList, paginationInfo):
                state.questionList = questionList
                state.paginationInfo = paginationInfo
                return .none
                
            case let .paginationResponse(questionList, paginationInfo):
                state.questionList += questionList
                state.paginationInfo = paginationInfo
                return .none
                
            case let .questionCellTapped(question):
                print(question)
                return .none
                
            case let .answerButtonTapped(question):
                print(question)
                return .none
            }
        }
    }
}
