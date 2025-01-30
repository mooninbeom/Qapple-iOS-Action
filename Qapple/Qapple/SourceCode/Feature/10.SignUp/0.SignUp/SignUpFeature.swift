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
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case path(StackActionOf<Path>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
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
