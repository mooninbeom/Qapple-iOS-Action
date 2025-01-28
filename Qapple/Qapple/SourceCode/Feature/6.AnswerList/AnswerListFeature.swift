//
//  AnswerListFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/24/25.
//

import ComposableArchitecture

@Reducer
struct AnswerListFeature {
    
    @ObservableState
    struct State: Equatable {
        var question: Question
        var answerList: [Answer] = []
        var totalCount: QappleAPI.TotalCount = 0
        var paginationInfo = QappleAPI.PaginationInfo(threshold: "", hasNext: false)
        @Presents var sheet: Sheet.State?
    }
    
    enum Action {
        case onAppear
        case refresh
        case pagination
        case answerListResponse(
            [Answer],
            QappleAPI.TotalCount,
            QappleAPI.PaginationInfo
        )
        case paginagionResponse(
            [Answer],
            QappleAPI.PaginationInfo
        )
        case seeMoreAction(Answer)
        case backButtonTapped
        case sheet(PresentationAction<Sheet.Action>)
    }
    
    @Dependency(\.answerRepository) var answerRepository
    
    var body: some ReducerOf<Self> {
        Reduce {
            state,
            action in
            switch action {
            case .onAppear, .refresh:
                return .run { [question = state.question] send in
                    do {
                        let response = try await answerRepository.fetchAnswerListOfQuestion(
                            question.id, nil
                        )
                        await send(
                            .answerListResponse(
                                response.0,
                                response.1,
                                response.2
                            )
                        )
                    } catch {
                        print(error)
                    }
                }
                
            case .pagination:
                return .run { [state = state]  send in
                    let response = try await answerRepository.fetchAnswerListOfQuestion(
                        state.question.id,
                        state.paginationInfo.threshold
                    )
                    await send(.paginagionResponse(response.0, response.2))
                }
                
            case let .answerListResponse(answerList, totalCount, paginationInfo):
                state.answerList = answerList.reversed()
                state.totalCount = totalCount
                state.paginationInfo = paginationInfo
                return .none
                
            case let .paginagionResponse(answerList, paginationInfo):
                state.answerList.insert(contentsOf: answerList.reversed(), at: 0)
                state.paginationInfo = paginationInfo
                return .none
                
            case let .seeMoreAction(answer):
                state.sheet = .seeMore(
                    .init(
                        sheetTarget: answer.isMine ? .mine : .others,
                        sheetData: .answer(answer)
                    )
                )
                return .none
                
            case let .sheet(.presented(.seeMore(.alert(.presented(.confirmDeletion(sheetData)))))):
                guard case let .answer(answer) = sheetData else { return .none }
                return .run { send in
                    do {
                        try await answerRepository.deleteAnswer(answer.id)
                        await send(.sheet(.presented(.seeMore(.completionDeletion))))
                    } catch {
                        print(error)
                    }
                }
                
            case .sheet(.presented(.seeMore(.alert(.presented(.confirmCompletion))))):
                state.sheet = nil
                return .run { send in
                    await send(.refresh)
                }
                
            case .backButtonTapped, .sheet:
                return .none
            }
        }
        .ifLet(\.$sheet, action: \.sheet)
    }
}

// MARK: - Sheet

extension AnswerListFeature {
    
    @Reducer(state: .equatable)
    enum Sheet {
        case seeMore(SeeMoreSheetFeature)
    }
}
