//
//  ProfileEditFeature.swift
//  Qapple
//
//  Created by Simmons on 2/1/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ProfileEditFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var nickname: String = ""
        var nicknameCheck: Bool = false
        var isLoading = false
    }
    
    enum Action {
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)
        
        case backButtonTapped
        case successButtonTapped
        case failEdit
        case toggleLoading(Bool)
        
        enum Alert {
            case confirmFailEdit
        }
        
        enum Delegate {
            case confirmFailEdit
        }
    }
    
    @Dependency(\.memberRepository) var memberRepository
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert:
                return .none
                
            case .delegate:
                return .none
                
            case .backButtonTapped:
                // TODO: Navigation 처리
                return .none
                
            case .successButtonTapped:
                // TODO: Navigation 처리
                let nickname = state.nickname
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await memberRepository.editMyPage(nickname, nil)
                    } catch {
                        print(error)
                        await send(.failEdit)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
            case .failEdit:
                state.alert = .confirmFailEdit
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - ProfileEditAlert

extension AlertState where Action == ProfileEditFeature.Action.Alert {
    static let confirmFailEdit = Self {
        TextState("회원 정보 수정에 실패했습니다")
    } actions: {
        ButtonState(role: .cancel){
            TextState("확인")
        }
    } message: {
        TextState("다시 요청해주세요")
    }
}
