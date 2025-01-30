//
//  CompleteAnswerFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/27/25.
//

import ComposableArchitecture

@Reducer
struct CompleteAnswerFeature {
    
    @ObservableState
    struct State: Equatable {
        var question: Question
    }
    
    enum Action {
        case confirmButtonTapped(Question)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .confirmButtonTapped:
                return .none
            }
        }
    }
}
