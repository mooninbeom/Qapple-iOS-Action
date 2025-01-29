//
//  BulletinBoardSearchFeature.swift
//  Qapple
//
//  Created by Simmons on 1/29/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BulletinBoardSearchFeature {
    @ObservableState
    struct State: Equatable {
        var searchBoardList: [BulletinBoard] = []
        var searchText: String = ""
        var isLoading = false
        var threshold: Int?
        var hasNext: Bool = false
    }
    
    enum Action {
        case getSearchBoard
        case refreshSearBoard
        case fetchSearchBoard(([BulletinBoard], QappleAPI.PaginationInfo))
        
        case backButtonTapped
        case setSearchText(String)
        case cancelSearchDebounce
        case performSearch(String)
        case toggleLoading(Bool)
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.continuousClock) var clock
    @Dependency(\.bulletinBoardRepository) var bulletinBoardRepository
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .getSearchBoard:
                let searchText = state.searchText
                let threshold = state.threshold
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let data = try await bulletinBoardRepository.searchBoard(searchText, threshold)
                        await send(.fetchSearchBoard(data))
                    } catch {
                        print(error)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .refreshSearBoard:
                state.searchBoardList = []
                let searchText = state.searchText
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let data = try await bulletinBoardRepository.searchBoard(searchText, nil)
                        await send(.fetchSearchBoard(data))
                    } catch {
                        print(error)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .fetchSearchBoard((searchBoardList, paginationInfo)):
                state.searchBoardList.append(contentsOf: searchBoardList)
                state.threshold = Int(paginationInfo.threshold)
                state.hasNext = paginationInfo.hasNext
                return .none
                
            case .backButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }
                
            case let .setSearchText(searchText):
                state.searchText = searchText
                state.searchBoardList = []
                state.threshold = nil
                
                return .concatenate(
                    .cancel(id: "searchDebounce"),
                    .run { send in
                        try await self.clock.sleep(for: .seconds(1))
                        await send(.performSearch(searchText))
                    }
                        .cancellable(id: "searchDebounce", cancelInFlight: true)
                )
                
            case .cancelSearchDebounce:
                return .cancel(id: "searchDebounce")
                
            case let .performSearch(searchText):
                guard !searchText.isEmpty else { return .none }
                return .run { send in
                    await send(.getSearchBoard)
                }
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
            }
        }
    }
}
