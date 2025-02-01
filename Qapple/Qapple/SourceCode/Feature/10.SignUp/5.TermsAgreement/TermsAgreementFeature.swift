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
        var isAllTermsAgree = false
        var isTermsOfServiceAgree = false
        var isPrivacyPolicyAgree = false
        var isUserLicenseAgree = false
        var isLoading = false
        @Presents var sheet: Sheet.State?
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
        case toggleLoading(Bool)
        case sheet(PresentationAction<Sheet.Action>)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { send in
                    await dismiss()
                }
                
            case .nextButtonTapped:
                return .none
                
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
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case .sheet:
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
