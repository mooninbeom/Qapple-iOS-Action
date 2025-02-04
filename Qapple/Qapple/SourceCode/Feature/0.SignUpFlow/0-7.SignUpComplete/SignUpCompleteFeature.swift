//
//  SignUpCompleteFeature.swift
//  Qapple
//
//  Created by 김민준 on 2/1/25.
//

import ComposableArchitecture

@Reducer
struct SignUpCompleteFeature {
    
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action {
        case startButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startButtonTapped:
                return .none
            }
        }
    }
}
