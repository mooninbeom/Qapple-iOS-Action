//
//  MyAnswerListFeature.swift
//  Qapple
//
//  Created by Simmons on 2/2/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MyAnswerListFeature {
    
    @ObservableState
    struct State: Equatable {
        var myAnswerList: [AnswerOfProfile] = []
        var totalCount: QappleAPI.TotalCount = 0
        var paginationInfo = QappleAPI.PaginationInfo(threshold: "", hasNext: false)
        var isLoading = false
        @Presents var sheet: Sheet.State?
    }
    
    enum Action {
        case onAppear
        case onDisappear
        case refresh
        case pagination
        case answerListResponse(
            [AnswerOfProfile],
            QappleAPI.PaginationInfo
        )
        case paginagionResponse(
            [AnswerOfProfile],
            QappleAPI.PaginationInfo
        )
        case seeMoreAction(AnswerOfProfile)
        case backButtonTapped
        case toggleLoading(Bool)
        case sheet(PresentationAction<Sheet.Action>)
    }
    
    @Dependency(\.answerRepository) var answerRepository
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear, .refresh:
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let response = try await answerRepository.fetchAnswerListOfProfile(nil)
                        await send(.answerListResponse(response.0, response.1))
                    } catch {
                        print(error)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .onDisappear:
                return .none
                
            case .pagination:
                return .run { [state = state]  send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    let response = try await answerRepository.fetchAnswerListOfProfile(
                        Int(state.paginationInfo.threshold)
                    )
                    await send(.paginagionResponse(response.0, response.1))
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .answerListResponse(answerList, paginationInfo):
                state.myAnswerList = answerList
                state.paginationInfo = paginationInfo
                return .none
                
            case let .paginagionResponse(answerList, paginationInfo):
                state.myAnswerList.insert(contentsOf: answerList, at: 0)
                state.paginationInfo = paginationInfo
                return .none
                
            case let .seeMoreAction(answer):
                state.sheet = .seeMore(
                    .init(
                        sheetTarget: .mine,
                        sheetData: .myAnswer(answer)
                    )
                )
                return .none
                
            case let .sheet(.presented(.seeMore(.alert(.presented(.confirmDeletion(sheetData)))))):
                guard case let .answer(answer) = sheetData else { return .none }
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await answerRepository.deleteAnswer(answer.id)
                        await send(.sheet(.presented(.seeMore(.completionDeletion))))
                    } catch {
                        print(error)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .sheet(.presented(.seeMore(.alert(.presented(.confirmCompletion))))):
                state.sheet = nil
                return .run { send in
                    await send(.onDisappear)
                }
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case .backButtonTapped, .sheet:
                return .none
            }
        }
        .ifLet(\.$sheet, action: \.sheet)
    }
}

// MARK: - Sheet

extension MyAnswerListFeature {
    
    @Reducer(state: .equatable)
    enum Sheet {
        case seeMore(SeeMoreSheetFeature)
    }
}
