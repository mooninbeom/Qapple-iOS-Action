//
//  TodayQuestionFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/21/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct TodayQuestionFeature {
    
    @ObservableState
    struct State: Equatable {
        var questionState: QuestionState
        var todayQuestion: QuestionEntity
        var answerPreviewList: [AnswerEntity] = []
        var timeRemainingForQuestion: TimeInterval = 0
    }
    
    enum Action {
        case onAppear
        case refresh
        case questionButtonTapped
        case seeAllAnswerButtonTapped
        case seeMoreAnswerButtonTapped(AnswerEntity)
        case questionTimerTick
    }
    
    enum CancelID {
        case questionTimer
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    // TODO: 오후 1시 ~ 오후 8시 질문 생성 시간에만 작동하게 만들기
                    for await _ in clock.timer(interval: .seconds(1)) {
                        await send(.questionTimerTick)
                    }
                }
                .cancellable(id: CancelID.questionTimer)
                
            case .refresh:
                return .none
                
            case .questionButtonTapped:
                return .none
                
            case .seeAllAnswerButtonTapped:
                return .none
                
            case let .seeMoreAnswerButtonTapped(answer):
                print(answer)
                return .none
                
            case .questionTimerTick:
                state.timeRemainingForQuestion += 1
                return .none
            }
        }
    }
}
