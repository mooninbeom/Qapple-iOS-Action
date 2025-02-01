//
//  AuthCodeFormFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture

@Reducer
struct AuthCodeFormFeature {
    
    @ObservableState
    struct State: Equatable {
        var emailText: String
        var authCodeText: String = ""
        var isAuthCodeEnterComplete = false
        var isAuthCodeValidate = true
        var isAuthCheckComplete = false
        var isLoading = false
        let authCodeLimit = 5
    }
    
    enum Action: BindableAction {
        case backButtonTapped
        case checkAuthCodeButtonTapped
        case reSendMailButtonTapped
        case checkAuthCodeResponse
        case checkAuthCodeFailed
        case nextButtonTapped
        case toggleLoading(Bool)
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.memberRepository) var memberRepository
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { send in
                    await dismiss()
                }
                
            case .checkAuthCodeButtonTapped:
                return .run { [state = state] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let _ = try await memberRepository.checkAuthCode(state.emailText, state.authCodeText)
                        await send(.checkAuthCodeResponse)
                    } catch {
                        await send(.checkAuthCodeFailed)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .reSendMailButtonTapped:
                state.authCodeText.removeAll()
                state.isAuthCodeEnterComplete = false
                state.isAuthCodeValidate = true
                return .run { [state = state] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let _ = try await memberRepository.checkAuthCode(state.emailText, state.authCodeText)
                        await send(.checkAuthCodeResponse)
                    } catch {
                        await send(.checkAuthCodeFailed)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .checkAuthCodeResponse:
                state.isAuthCheckComplete = true
                return .none
                
            case .checkAuthCodeFailed:
                state.isAuthCodeValidate = false
                return .none
                
            case .nextButtonTapped:
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case .binding(\.authCodeText):
                state.isAuthCodeValidate = true
                state.isAuthCodeEnterComplete = state.authCodeText.count >= 5
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
