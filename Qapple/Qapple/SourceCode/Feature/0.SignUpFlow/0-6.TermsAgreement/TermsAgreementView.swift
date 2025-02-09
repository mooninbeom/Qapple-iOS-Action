//
//  TermsAgreementView.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import SwiftUI

struct TermsAgreementView: View {
    
    @Bindable var store: StoreOf<TermsAgreementFeature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationBar(
                title: "약관 동의",
                leadingView: {
                    NavigationButton(buttonType: .back) {
                        store.send(.backButtonTapped)
                    }
                }
            )
            
            Text("가입까지 한 단계 남았어요")
                .font(.pretendard(.bold, size: 24))
                .foregroundStyle(.main)
                .padding(.top, 32)
                .padding(.horizontal, 24)
            
            Text("회원가입을 위해서는 모든 약관에 동의가 필요해요")
                .font(.pretendard(.medium, size: 16))
                .foregroundStyle(.sub3)
                .lineLimit(2)
                .padding(.top, 12)
                .padding(.horizontal, 24)
            
            TermsList(store: store)
                .padding(.top, 40)
                .padding(.horizontal, 24)
            
            ScrollView {
                Text(Constant.termsSummary)
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(.sub4)
                    .lineSpacing(6)
            }
            .padding(.top, 32)
            .padding(.bottom, 16)
            .padding(.horizontal, 24)
            
            Spacer()
            
            ActionButton("다음", isActive: store.isAllTermsAgree) {
                store.send(.nextButtonTapped)
            }
            .padding(.bottom, 16)
            .padding(.horizontal, 24)
        }
        .background(.first)
        .navigationBarBackButtonHidden()
        .loadingIndicator(isLoading: store.isLoading)
        .alert($store.scope(state: \.alert, action: \.alert))
        .sheet(item: $store.scope(state: \.sheet, action: \.sheet)) { sheet in
            switch sheet.case {
            case .termsOfService: TermsContentView(title: "서비스 이용 약관", content: Constant.termsOfService)
            case .privacyPolicy: TermsContentView(title: "개인정보 처리 방침", content: Constant.privacyPolicy)
            }
        }
    }
}

// MARK: - TermsList

private struct TermsList: View {
    
    let store: StoreOf<TermsAgreementFeature>
    
    var body: some View {
        VStack(spacing: 24) {
            TermCell(
                title: "전체 약관 동의",
                isActive: store.isAllTermsAgree,
                toggleCheckBox: {
                    store.send(.allTermsAgreeButtonTapped, animation: .bouncy)
                }
            )
            TermCell(
                title: "* 필수) 서비스 이용 약관",
                isActive: store.isTermsOfServiceAgree,
                goToPageAction: {
                    store.send(.termsOfServicePageButtonTapped)
                },
                toggleCheckBox: {
                    store.send(.termsOfServiceAgreeButtonTapped, animation: .bouncy)
                }
            )
            TermCell(
                title: "* 필수) 개인정보 처리방침",
                isActive: store.isPrivacyPolicyAgree,
                goToPageAction: {
                    store.send(.privacyPolicyPageButtonTapped)
                },
                toggleCheckBox: {
                    store.send(.privacyPolicyAgreeButtonTapped, animation: .bouncy)
                }
            )
            TermCell(
                title: "* 필수) 최종 사용자 사용권 계약",
                isActive: store.isUserLicenseAgree,
                toggleCheckBox: {
                    store.send(.userLicenseAgreeButtonTapped, animation: .bouncy)
                }
            )
        }
    }
}

// MARK: - TermCell

private struct TermCell: View {
    
    let title: String
    let isActive: Bool
    let goToPageAction: (() -> Void)?
    let toggleCheckBox: () -> Void
    
    init(
        title: String,
        isActive: Bool,
        goToPageAction: (() -> Void)? = nil,
        toggleCheckBox: @escaping () -> Void
    ) {
        self.title = title
        self.isActive = isActive
        self.goToPageAction = goToPageAction
        self.toggleCheckBox = toggleCheckBox
    }
    
    var body: some View {
        HStack(spacing: 16) {
            if let goToPageAction = goToPageAction {
                Button {
                    goToPageAction()
                } label: {
                    Text(title)
                        .font(.pretendard(.semiBold, size: 16))
                        .foregroundStyle(.sub2)
                    
                    Spacer()
                    
                    Image(.arrowRight)
                }
            } else {
                Text(title)
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundStyle(.sub2)
                
                Spacer()
            }
            
            Button {
                toggleCheckBox()
            } label: {
                Image(isActive ? .checkboxActive : .checkboxInActive)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    TermsAgreementView(
        store: Store(
            initialState: TermsAgreementFeature.State(
                emailText: "",
                nicknameText: ""
            )
        ) {
        TermsAgreementFeature()
    })
}
