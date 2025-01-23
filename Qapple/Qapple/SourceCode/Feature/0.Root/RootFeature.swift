//
//  RootFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/20/25.
//

import ComposableArchitecture

@Reducer
struct RootFeature {
    
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case path(StackActionOf<Path>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            default: return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

// MARK: - Path

extension RootFeature {
    
    @Reducer(state: .equatable)
    enum Path {
        
    }
}
