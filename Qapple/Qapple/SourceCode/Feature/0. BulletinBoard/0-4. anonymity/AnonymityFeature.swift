//
//  AnonymityFeature.swift
//  Qapple
//
//  Created by Simmons on 1/28/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct AnonymityFeature {
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action {
        case confirmButtonTapped
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .confirmButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }
            }
        }
    }
}
