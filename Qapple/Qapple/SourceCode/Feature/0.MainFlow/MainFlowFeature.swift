//
//  MainFlowFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/20/25.
//

import ComposableArchitecture

@Reducer
struct MainFlowFeature {
    
    @ObservableState
    struct State: Equatable {
        var questionTab = QuestionTabFeature.State()
        var bulletinBoardTab = BulletinBoardFeature.State()
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case questionTab(QuestionTabFeature.Action)
        case bulletinBoardTab(BulletinBoardFeature.Action)
        case path(StackActionOf<Path>)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.questionTab, action: \.questionTab) {
            QuestionTabFeature()
        }
        Scope(state: \.bulletinBoardTab, action: \.bulletinBoardTab) {
            BulletinBoardFeature()
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
                
            case let .questionTab(.questionList(.questionCellTapped(question))):
                if question.isAnswered {
                    state.path.append(.answerList(.init(question: question)))
                }
                return .none
                
            case let .questionTab(.questionList(.answerButtonTapped(question))):
                state.path.append(.writeAnswer(.init(question: question)))
                return .none
                
            case .questionTab(.alertButtonTapped):
                state.path.append(.notificationList(.init()))
                return .none
                
            case let .bulletinBoardTab(.boardButtonTapped(board)):
                state.path.append(.commentView(.init(post: board)))
                return .none
                
            case let .path(stackAction):
                switch stackAction {
                case let .element(id: _, action: .writeAnswer(.postAnswerResponse(question))):
                    state.path.append(.completeAnswer(.init(question: question)))
                    return .none
                    
                case let .element(id: _, action: .completeAnswer(.confirmButtonTapped(question))):
                    state.path.append(.answerList(.init(question: question)))
                    return .none
                    
                case .element(id: _, action: .answerList(.backButtonTapped)):
                    state.path.removeAll()
                    return .none
                    
                case .element(id: _, action: .answerList(.onDisappear)):
                    state.path.removeAll()
                    return .none
                    
                default:
                    return .none
                }
                
            default: return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

// MARK: - Path

extension MainFlowFeature {
    
    @Reducer(state: .equatable)
    enum Path {
        case notificationList(NotificationFeature)
        case writeAnswer(WriteAnswerFeature)
        case completeAnswer(CompleteAnswerFeature)
        case answerList(AnswerListFeature)
        case bulletinBoardView(BulletinBoardFeature)
        case commentView(CommentFeature)
    }
}
