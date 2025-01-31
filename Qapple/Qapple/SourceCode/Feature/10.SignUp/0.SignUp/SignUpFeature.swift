//
//  SignUpFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture

@Reducer
struct SignUpFeature {
    
    @ObservableState
    struct State: Equatable {
        var isSignIn = false
        var socialLogin = SocialLoginFeature.State()
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case socialLogin(SocialLoginFeature.Action)
        case path(StackActionOf<Path>)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.socialLogin, action: \.socialLogin) {
            SocialLoginFeature()
        }
        Reduce { state, action in
            switch action {
            case let .socialLogin(.delegate(.signInResponse(isSignUp))):
                if isSignUp {
                    state.isSignIn = true
                } else {
                    state.path.append(.emailForm(.init()))
                }
                return .none
                
            case let .path(stackAction):
                switch stackAction {
                case let .element(id: _, action: .emailForm(.sendCertificationEmailResponse(email))):
                    state.path.append(.authCodeForm(.init(emailText: email)))
                    return .none
                    
                case .element(id: _, action: .authCodeForm(.nextButtonTapped)):
                    state.path.append(.nicknameForm(.init()))
                    return .none
                    
                default:
                    return .none
                }
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

// MARK: - Path

extension SignUpFeature {
    
    @Reducer(state: .equatable)
    enum Path {
        case emailForm(EmailFormFeature)
        case authCodeForm(AuthCodeFormFeature)
        case nicknameForm(NicknameFormFeature)
        case termsAgreement(TermsAgreementFeature)
    }
}
