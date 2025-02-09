//
//  EmailFormFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture

@Reducer
struct EmailFormFeature {
    
    @ObservableState
    struct State: Equatable {
        var emailText = ""
        var isEmailTextValid = false
        var isLoading = false
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action: BindableAction {
        case backButtonTapped
        case sendMailButtonTapped
        case sendCertificationEmailResponse(String)
        case sendCertificationEmailFailed
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
                
            case .sendMailButtonTapped:
                return .run { [email = state.emailText + Constant.academyEmail]  send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let _ = try await memberRepository.sendCertificationEmail(email)
                        await send(.sendCertificationEmailResponse(email))
                    } catch {
                        await send(.sendCertificationEmailFailed)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .sendCertificationEmailResponse:
                return .none
                
            case .sendCertificationEmailFailed:
                state.alert = .existEmail
                HapticService.notification(type: .error)
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case .binding(\.emailText):
                state.isEmailTextValid = !state.emailText.isEmpty
                return .none
                
            case .alert, .binding:
                return .none
            }
        }
    }
}

// MARK: - Alert

extension AlertState where Action == EmailFormFeature.Action.Alert {
    static let existEmail = AlertState {
        TextState("이미 가입된 이메일이에요")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("확인")
        }
    } message: {
        TextState("다른 이메일을 입력해주세요")
    }
}
