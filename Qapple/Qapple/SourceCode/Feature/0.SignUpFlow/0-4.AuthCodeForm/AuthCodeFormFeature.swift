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
        let emailText: String
        let authCodeLimit = 5
        var authCodeText: String = ""
        var isAuthCodeEnterComplete = false
        var isAuthCodeValidate = true
        var isAuthCheckComplete = false
        var isLoading = false
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action: BindableAction {
        case backButtonTapped
        case checkAuthCodeButtonTapped
        case reSendMailButtonTapped
        case checkAuthCodeResponse
        case resendMailResponse
        case checkAuthCodeFailed
        case reSendMailFailed
        case nextButtonTapped
        case authCodeFormComplete(email: String)
        case toggleLoading(Bool)
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        
        enum Alert: Equatable {}
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
                        await send(.reSendMailResponse)
                    } catch {
                        await send(.reSendMailFailed)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .checkAuthCodeResponse:
                state.isAuthCheckComplete = true
                return .none
                
            case .reSendMailResponse:
                state.alert = .reSendMail
                return .none
                
            case .checkAuthCodeFailed:
                state.alert = .invalidAuthCode
                state.isAuthCodeValidate = false
                HapticService.notification(type: .error)
                return .none
                
            case .reSendMailFailed:
                state.alert = .failedReSendMail
                HapticService.notification(type: .error)
                return .none
                
            case .nextButtonTapped:
                return .run { [email = state.emailText] send in
                    await send(.authCodeFormComplete(email: email))
                }
                
            case .authCodeFormComplete:
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case .binding(\.authCodeText):
                state.isAuthCodeValidate = true
                state.isAuthCodeEnterComplete = state.authCodeText.count >= 5
                return .none
                
            case .alert, .binding:
                return .none
            }
        }
    }
}

// MARK: - Alert

extension AlertState where Action == AuthCodeFormFeature.Action.Alert {
    static let invalidAuthCode = AlertState {
        TextState("인증 코드가 일치하지 않아요")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("확인")
        }
    } message: {
        TextState("메일함의 인증코드를 다시 확인해주세요")
    }
    
    static let reSendMail = AlertState {
        TextState("메일이 재발송 되었어요")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("확인")
        }
    }
    
    static let failedReSendMail = AlertState {
        TextState("메일 재발송에 실패했어요")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("확인")
        }
    } message: {
        TextState("잠시 후 다시 시도해주세요")
    }
}
