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
            case .onAppear, .refresh:
                return .run { send in
                    do {
                        let mainQuestion = try await fetchMainQuestion()
                        let answerList = try await fetchAnswerPreviewList(mainQuestion.id)
                        await send(.mainQuestionResponse(mainQuestion))
                        await send(.answerListResponse(answerList))
                    } catch {
                        print(error)
                    }
                }
                
            case .onDisappear:
                return .cancel(id: CancelID.questionTimer)
                
            case let .mainQuestionResponse(mainQuestion):
                state.todayQuestion = mainQuestion
                if isQuestionLiveTime {
                    state.questionState = mainQuestion.isAnswered ? .complete : .ready
                    return .none
                } else {
                    state.questionState = .creating
                    state.timeRemainingForQuestion = timeLeftForQuestion
                    return .run { send in
                        for await _ in clock.timer(interval: .seconds(1)) {
                            await send(.questionTimerTick)
                        }
                    }
                    .cancellable(id: CancelID.questionTimer)
                }
                
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
                state.timeRemainingForQuestion -= 1
                return .none
            }
        }
    }
}

// MARK: - Helper

extension TodayQuestionFeature {
    
    /// 현재 질문 라이브 시간인지 확인하는 계산 속성
    ///
    /// 질문 라이브 시간: 오후 1시 ~ 오후 8시
    private var isQuestionLiveTime: Bool {
        let currentHour = Calendar.current.component(.hour, from: .now)
        return (13...20).contains(currentHour)
    }
    
    /// 다음 질문 생성까지 남은 시간을 계산하는 속성
    ///
    /// 질문 생성 시간: 오후 1시
    private var timeLeftForQuestion: TimeInterval {
        let calendar = Calendar.current
        var nextQuestionDate = calendar.date(bySettingHour: 13, minute: 0, second: 0, of: .now)!
        if Date.now > nextQuestionDate {
            nextQuestionDate = calendar.date(byAdding: .day, value: 1, to: nextQuestionDate)!
        }
        return nextQuestionDate.timeIntervalSinceNow
    }
}
