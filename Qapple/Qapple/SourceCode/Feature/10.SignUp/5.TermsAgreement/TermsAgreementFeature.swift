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
        case userLicensePageButtonTapped
        case toggleLoading(Bool)
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
                return .none
                
            case .privacyPolicyPageButtonTapped:
                return .none
                
            case .userLicensePageButtonTapped:
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
            }
        }
    }
}
