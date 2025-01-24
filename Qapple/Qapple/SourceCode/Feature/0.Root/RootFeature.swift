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
        var questionTab = QuestionTabFeature.State()
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case questionTab(QuestionTabFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.questionTab, action: \.questionTab) {
            QuestionTabFeature()
        }
        Reduce { state, action in
            switch action {
            case let .questionTab(.todayQuestion(.questionButtonTapped(question))):
                if question.isAnswered {
                    state.path.append(.answerList(.init(question: question)))
                } else {
                    state.path.append(.writeAnswer(.init(question: question)))
                }
                return .none
                
            case let .questionTab(.todayQuestion(.seeAllAnswerButtonTapped(question))):
                state.path.append(.answerList(.init(question: question)))
                return .none
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
        case writeAnswer(WriteAnswerFeature)
        case answerList(AnswerListFeature)
    }
}
