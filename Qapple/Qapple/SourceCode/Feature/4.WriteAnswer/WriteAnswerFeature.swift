//
//  WriteAnswerFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/24/25.
//

import ComposableArchitecture

@Reducer
struct WriteAnswerFeature {
    
    @ObservableState
    struct State: Equatable {
        var question: Question
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}
