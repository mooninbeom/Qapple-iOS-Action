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
        var questionState: QuestionState = .creating
        var todayQuestion: Question = .initialState
        var answerPreviewList: [Answer] = []
        var timeRemainingForQuestion: TimeInterval = 0
    }
    
    enum Action {
        case onAppear
        case onDisappear
        case refresh
        case mainQuestionResponse(Question)
        case answerListResponse([Answer])
        case questionButtonTapped
        case seeAllAnswerButtonTapped
        case seeMoreAnswerButtonTapped(Answer)
        case questionTimerTick
    }
    
    enum CancelID {
        case questionTimer
    }
    
    @Dependency(\.questionRepository.fetchMainQuestion) var fetchMainQuestion
    @Dependency(\.answerRepository.fetchAnswerPreviewList) var fetchAnswerPreviewList
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    do {
                        let mainQuestion = try await fetchMainQuestion()
                        let answerList = try await fetchAnswerPreviewList(mainQuestion.id)
                        await send(.mainQuestionResponse(mainQuestion))
                        await send(.answerListResponse(answerList))
                    } catch {
                        print(error)
                    }
                    
                    // TODO: 오후 1시 ~ 오후 8시 질문 생성 시간에만 작동하게 만들기
                    for await _ in clock.timer(interval: .seconds(1)) {
                        await send(.questionTimerTick)
                    }
                }
                .cancellable(id: CancelID.questionTimer)
                
            case .onDisappear:
                return .cancel(id: CancelID.questionTimer)
                
            case .refresh:
                return .run { send in
                    do {
                        let mainQuestion = try await fetchMainQuestion()
                        await send(.mainQuestionResponse(mainQuestion))
                    } catch {
                        print(error)
                    }
                }
                
            case let .mainQuestionResponse(mainQuestion):
                state.todayQuestion = mainQuestion
                return .none
                
            case let .answerListResponse(answerList):
                state.answerPreviewList = answerList
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
