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
        var searchBoard: [BulletinBoard] = []
        var searchText: String = ""
        var isLoading = false
        var threshold: Int?
        var hasNext: Bool = false
    }
    
    enum Action {
        case backButtonTapped
        case setSearchText(String)
        case performSearch(String)
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }
                
            case let .setSearchText(searchText):
                state.searchText = searchText
                state.searchBoard = []
                state.threshold = nil
                return .run { send in
                    try await self.clock.sleep(for: .seconds(1))
                    await send(.performSearch(searchText))
                }
                
            case let .performSearch(query):
                guard !query.isEmpty else { return .none }
                state.isLoading = true
                return .run { send in
                    // TODO: 검색 api
                }
            }
        }
    }
}

func searchPost(keyword: String) async -> [BulletinBoard] {
    // 여기에 실제 검색 로직을 구현
    return []
}
