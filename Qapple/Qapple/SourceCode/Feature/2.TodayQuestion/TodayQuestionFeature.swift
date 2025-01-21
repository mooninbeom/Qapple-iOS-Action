//
//  TodayQuestionFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/21/25.
//

import ComposableArchitecture

@Reducer
struct TodayQuestionFeature {
    
    @ObservableState
    struct State: Equatable {
        var answerPreviewList: [Answer]
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            <#code#>
        }
    }
}
