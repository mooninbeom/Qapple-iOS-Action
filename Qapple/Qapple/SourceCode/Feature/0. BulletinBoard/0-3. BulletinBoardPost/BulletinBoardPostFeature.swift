//
//  BulletinBoardPostFeature.swift
//  Qapple
//
//  Created by Simmons on 1/28/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BulletinBoardPostFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var isLoading = false
        var content: String = ""
        var fontSize: CGFloat = 48
        var textCountLimit = 150
    }
    
    enum Action {
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)
        
        case cancelButtonTapped
        case setContent(String)
        
        enum Alert {
            case confirmCancel
        }
        
        enum Delegate {
            case confirmCancel
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert(.presented(.confirmCancel)):
                return .run { send in
                    await send(.delegate(.confirmCancel))
                }
                
            case .alert:
                return .none
                
            case .delegate:
                return .none
                
            case .cancelButtonTapped:
                if state.content == "" {
                    // TODO: Navigation 처리
                } else {
                    state.alert = .confirmCancel
                }
                return .none
                
            case let .setContent(content):
                state.content = content
                
                if content.count > state.textCountLimit {
                    state.content = String(content.prefix(state.textCountLimit))
                } else {
                    state.content = content
                }
                
                switch state.content.count {
                case 0..<20: state.fontSize = 48
                case 20..<32: state.fontSize = 40
                case 32..<60: state.fontSize = 32
                case 60...100: state.fontSize = 24
                case 100...: state.fontSize = 17
                default: break
                }
                
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - BulletinBoardPostAlert

extension AlertState where Action == BulletinBoardPostFeature.Action.Alert {
    static let confirmCancel = Self {
        TextState("정말 그만두시겠어요?")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("취소")
        }
        ButtonState(role: .destructive, action: .confirmCancel) {
            TextState("그만두기")
        }
    } message: {
        TextState("지금까지 작성한 답변이 사라져요")
    }
}
