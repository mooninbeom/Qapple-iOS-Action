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
        @Presents var alert: AlertState<Action.Alert>?
        var questionList: [QuestionEntity] = []
        var totalCount: QappleAPI.TotalCount = 0
        var paginationInfo = QappleAPI.PaginationInfo(threshold: "", hasNext: false)
    }
    
    enum Action {
        case onAppear
        case refresh
        case pagination
        case questionListResponse([QuestionEntity], QappleAPI.TotalCount, QappleAPI.PaginationInfo)
        case paginationResponse([QuestionEntity], QappleAPI.PaginationInfo)
        case questionCellTapped(QuestionEntity)
        case answerButtonTapped(QuestionEntity)
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {
            case confirmButtonTapped
        }
    }
    
    @Dependency(\.questionRepository.fetchQuestionList) var fetchQuestionList
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear, .refresh:
                return .run { send in
                    do {
                        let response = try await fetchQuestionList(nil)
                        await send(.questionListResponse(response.0, response.1, response.2))
                    } catch {
                        print(error)
                    }
                }
                
            case .pagination:
                return .run { [threshold = state.paginationInfo.threshold] send in
                    do {
                        let response = try await fetchQuestionList(threshold)
                        await send(.paginationResponse(response.0, response.2))
                    } catch {
                        print(error)
                    }
                }
                
            case let .questionListResponse(questionList, totalCount, paginationInfo):
                state.questionList = questionList
                state.totalCount = totalCount
                state.paginationInfo = paginationInfo
                return .none
                
            case let .paginationResponse(questionList, paginationInfo):
                state.questionList += questionList
                state.paginationInfo = paginationInfo
                return .none
                
            case let .questionCellTapped(question):
                if !question.isAnswered {
                    state.alert = .answeringCheck
                }
                return .none
                
            case let .answerButtonTapped(question):
                print(question)
                return .none
                
            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - Alert

extension AlertState where Action == QuestionListFeature.Action.Alert {
    static let answeringCheck = AlertState {
        TextState("답변하면 확인이 가능해요 😀")
    } actions: {
        ButtonState(role: .none) {
            TextState("확인")
        }
    } message: {
        TextState("즐거운 커뮤니티 운영을 위해\n여러분의 답변을 들려주세요")
    }
}
