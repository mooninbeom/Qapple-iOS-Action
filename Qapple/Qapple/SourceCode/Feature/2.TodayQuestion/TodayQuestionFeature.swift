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
        var questionState: QuestionState
        var todayQuestion: QuestionEntity
        var answerPreviewList: [AnswerEntity] = []
    }
    
    enum Action {
        case questionButtonTapped
        case seeAllAnswerButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .questionButtonTapped:
                return .none
                
            case .seeAllAnswerButtonTapped:
                return .none
            }
        }
    }
}
