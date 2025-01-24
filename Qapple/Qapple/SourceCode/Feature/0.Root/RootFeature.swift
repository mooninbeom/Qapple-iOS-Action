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
        var bulletinBoardTab = BulletinBoardFeature.State()
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case questionTab(QuestionTabFeature.Action)
        case bulletinBoardTab(BulletinBoardFeature.Action)
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
                
            case let .path(action):
                switch action {
                default: return .none
                }
                
            case let .bulletinBoardTab(.boardButtonTapped(board)):
                state.path.append(.commentView(.init(post: board)))
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
        case bulletinBoardView(BulletinBoardFeature)
        case commentView(CommentFeature)
    }
}
