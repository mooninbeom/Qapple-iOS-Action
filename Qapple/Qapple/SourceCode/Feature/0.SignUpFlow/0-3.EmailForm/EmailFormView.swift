//
//  EmailFormView.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import SwiftUI

struct EmailFormView: View {
    
    @Bindable var store: StoreOf<EmailFormFeature>
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationBar(
                title: "회원가입",
                leadingView: {
                    NavigationButton(buttonType: .back) {
                        store.send(.backButtonTapped)
                    }
                }
            )
            
            Text("이메일을 입력해주세요")
                .font(.pretendard(.bold, size: 24))
                .foregroundStyle(.main)
                .padding(.top, 32)
                .padding(.horizontal, 24)
            
            QPTextField(
                textString: $store.emailText,
                isTextFieldFocused: $isTextFieldFocused,
                title: "이메일",
                placeholder: "이메일 주소를 입력해주세요",
                helperText: "* 아카데미 계정 아이디를 입력해주세요",
                state: .default,
                topTrailingView: {
                    Text(Constant.academyEmail)
                        .foregroundStyle(store.emailText.isEmpty ? .placeholder : .wh)
                        .font(.pretendard(.semiBold, size: 14))
                        .frame(height: 8)
                },
                bottomTrailingView: {
                    QPSubButton(
                        title: "메일 발송",
                        isActive: store.isEmailTextValid || store.isLoading,
                        variation: .primary,
                        tapAction: {
                            store.send(.sendMailButtonTapped)
                        }
                    )
                }
            )
            .padding(.top, 64)
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .background(.first)
        .navigationBarBackButtonHidden()
        .loadingIndicator(isLoading: store.isLoading)
        .alert($store.scope(state: \.alert, action: \.alert))
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
}

// MARK: - Preview

#Preview {
    EmailFormView(store: Store(initialState: EmailFormFeature.State()) {
        EmailFormFeature()
    })
}
