//
//  SignUpView.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import SwiftUI

struct SignUpView: View {
    
    @Bindable var store: StoreOf<SignUpFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            SocialLoginView(store: store.scope(state: \.socialLogin, action: \.socialLogin))
        } destination: { store in
            switch store.case {
            case let .emailForm(store): EmailFormView(store: store)
            case let .authCodeForm(store): AuthCodeFormView(store: store)
            case let .nicknameForm(store): NicknameFormView(store: store)
            case let .termsAgreement(store): TermsAgreementView(store: store)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SignUpView(store: Store(initialState: SignUpFeature.State()) {
        SignUpFeature()
    })
}
