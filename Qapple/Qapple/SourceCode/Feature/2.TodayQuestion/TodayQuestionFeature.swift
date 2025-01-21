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
        case onAppear
        case refresh
        case questionButtonTapped
        case seeAllAnswerButtonTapped
        case seeMoreAnswerButtonTapped(Answer)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case .refresh:
                return .none
                
            case .questionButtonTapped:
                return .none
                
            case .seeAllAnswerButtonTapped:
                return .none
                
            case let .seeMoreAnswerButtonTapped(answer):
                print(answer)
                return .none
            }
        }
    }
}
