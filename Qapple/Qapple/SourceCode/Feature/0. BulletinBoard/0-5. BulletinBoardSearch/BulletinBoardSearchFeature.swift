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
        var isLoading = false
        var searchText: String = ""
    }
    
    enum Action {
        case backButtonTapped
        case setSearchText(String)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }
                
            case let .setSearchText(searchText):
                state.searchText = searchText
                return .none
            }
        }
    }
}
