//
//  QuestionTabFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/23/25.
//

import ComposableArchitecture

@Reducer
struct QuestionTabFeature {
    
    @ObservableState
    struct State: Equatable {
        var questionTab: QuestionTab = .todayQuestion
        var todayQuestion = TodayQuestionFeature.State()
        var questionList = QuestionListFeature.State()
    }
    
    enum Action {
        case switchTab(QuestionTab)
        case todayQuestionTabButtonTapped
        case questionListTabButtonTapped
        case alertButtonTapped
        case todayQuestion(TodayQuestionFeature.Action)
        case questionList(QuestionListFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.todayQuestion, action: \.todayQuestion) {
            TodayQuestionFeature()
        }
        Scope(state: \.questionList, action: \.questionList) {
            QuestionListFeature()
        }
        Reduce { state, action in
            switch action {
            case let .switchTab(questionTab):
                state.questionTab = questionTab
                return .none
                
            case .todayQuestionTabButtonTapped:
                state.questionTab = .todayQuestion
                return .none
                
            case .questionListTabButtonTapped:
                state.questionTab = .questionList
                return .none
                
            case .alertButtonTapped:
                return .none
                
            default:
                return .none
            }
        }
    }
}

// MARK: - QuestionTab

extension QuestionTabFeature {
    
    enum QuestionTab {
        case todayQuestion
        case questionList
    }
}
