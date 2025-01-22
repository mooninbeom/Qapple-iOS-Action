//
//  QuestionListFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/22/25.
//

import ComposableArchitecture

@Reducer
struct QuestionListFeature {
    
    @ObservableState
    struct State: Equatable {
        var questionList: [QuestionEntity] = []
        var threshold: String?
        var haxNext = false
        var isPagination = false
    }
    
    enum Action {
        case onAppear
        case pagination
        case answerButtonTapped(QuestionEntity)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case .pagination:
                return .none
                
            case let .answerButtonTapped(question):
                print(question)
                return .none
            }
        }
    }
}
