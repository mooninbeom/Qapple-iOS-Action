//
//  TermsAgreementFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture

@Reducer
struct TermsAgreementFeature {
    
    @ObservableState
    struct State: Equatable {
        let emailText: String
        let nicknameText: String
        var isAllTermsAgree = false
        var isTermsOfServiceAgree = false
        var isPrivacyPolicyAgree = false
        var isUserLicenseAgree = false
        var isLoading = false
        @Presents var sheet: Sheet.State?
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case backButtonTapped
        case nextButtonTapped
        case allTermsAgreeButtonTapped
        case termsOfServiceAgreeButtonTapped
        case privacyPolicyAgreeButtonTapped
        case userLicenseAgreeButtonTapped
        case termsOfServicePageButtonTapped
        case privacyPolicyPageButtonTapped
        case signUpResponse
        case signUpFailed
        case toggleLoading(Bool)
        case sheet(PresentationAction<Sheet.Action>)
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {}
    }
    
    @Dependency(\.memberRepository) var memberRepository
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { send in
                    await dismiss()
                }
                
            case .nextButtonTapped:
                return .run { [email = state.emailText, nickname = state.nicknameText] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await memberRepository.signUp(email, nickname)
                        await send(.signUpResponse)
                    } catch {
                        await send(.signUpFailed)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .allTermsAgreeButtonTapped:
                state.isAllTermsAgree.toggle()
                state.isTermsOfServiceAgree = state.isAllTermsAgree
                state.isPrivacyPolicyAgree = state.isAllTermsAgree
                state.isUserLicenseAgree = state.isAllTermsAgree
                return .none
                
            case .termsOfServiceAgreeButtonTapped:
                state.isTermsOfServiceAgree.toggle()
                state.isAllTermsAgree = state.isTermsOfServiceAgree
                && state.isPrivacyPolicyAgree
                && state.isUserLicenseAgree
                return .none
                
            case .privacyPolicyAgreeButtonTapped:
                state.isPrivacyPolicyAgree.toggle()
                state.isAllTermsAgree = state.isTermsOfServiceAgree
                && state.isPrivacyPolicyAgree
                && state.isUserLicenseAgree
                return .none
                
            case .userLicenseAgreeButtonTapped:
                state.isUserLicenseAgree.toggle()
                state.isAllTermsAgree = state.isTermsOfServiceAgree
                && state.isPrivacyPolicyAgree
                && state.isUserLicenseAgree
                return .none
                
            case .termsOfServicePageButtonTapped:
                state.sheet = .termsOfService
                return .none
                
            case .privacyPolicyPageButtonTapped:
                state.sheet = .privacyPolicy
                return .none
                
            case .signUpResponse:
                return .none
                
            case .signUpFailed:
                state.alert = .failedSignUp
                HapticService.notification(type: .error)
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case .sheet, .alert:
                return .none
            }
        }
        .ifLet(\.$sheet, action: \.sheet)
    }
}


// MARK: - Sheet

extension TermsAgreementFeature {
    
    @Reducer(state: .equatable)
    enum Sheet {
        case termsOfService
        case privacyPolicy
    }
}

// MARK: - Alert

extension AlertState where Action == TermsAgreementFeature.Action.Alert {
    static let failedSignUp = AlertState {
        TextState("네트워크 연결이 불안정해요")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("확인")
        }
    } message: {
        TextState("잠시 후 다시 시도해주세요")
    }
}
