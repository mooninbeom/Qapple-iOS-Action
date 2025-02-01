//
//  AuthCodeFormView.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import SwiftUI

struct AuthCodeFormView: View {
    
    @Bindable var store: StoreOf<AuthCodeFormFeature>
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationBar(
                title: "회원가입",
                leadingView: {
                    NavigationButton(buttonType: .back) {
                        store.send(.backButtonTapped)
                    }
                }
            )
            
            Text("인증 메일을 발송했어요")
                .font(.pretendard(.bold, size: 24))
                .foregroundStyle(.main)
                .padding(.top, 32)
                .padding(.horizontal, 24)
            
            Text("\(store.emailText) 메일함을 확인해주세요")
                .font(.pretendard(.medium, size: 16))
                .foregroundStyle(.sub3)
                .lineLimit(2)
                .padding(.top, 4)
                .padding(.horizontal, 24)
            
            QPTextField(
                textString: $store.authCodeText,
                isTextFieldFocused: $isTextFieldFocused,
                title: "인증 코드",
                placeholder: "인증 코드를 입력해주세요",
                helperText: helperText,
                state: store.isAuthCodeValidate ? .default : .inValid,
                topTrailingView: {
                    if store.isAuthCheckComplete { CheckAuthCodeIcon() }
                    else { CheckAuthCodeButton() }
                },
                bottomTrailingView: {
                    if !store.isAuthCheckComplete {
                        QPSubButton(
                            title: "메일 재발송",
                            isActive: true,
                            variation: .secondary,
                            tapAction: {
                                store.send(.reSendMailButtonTapped)
                            }
                        )
                    }
                }
            )
            .padding(.top, 64)
            .padding(.horizontal, 24)
            .disabled(store.isAuthCheckComplete)
            .onChange(of: store.authCodeText) { _, value in
                store.authCodeText = value.slice(to: store.authCodeLimit)
                store.authCodeText = value.uppercased()
            }
            
            Spacer()
            
            ActionButton("다음", isActive: store.isAuthCheckComplete) {
                store.send(.nextButtonTapped)
            }
            .padding(.bottom, 16)
            .padding(.horizontal, 24)
        }
        .background(.first)
        .navigationBarBackButtonHidden()
        .loadingIndicator(isLoading: store.isLoading)
        .onChange(of: store.authCodeText) { _, value in
            if value.count >= store.authCodeLimit {
                isTextFieldFocused = false
            }
        }
    }
    
    private var helperText: String {
        guard !store.isAuthCheckComplete else { return "인증이 완료되었어요" }
        return store.isAuthCodeValidate
        ? "메일이 오지 않았나요? 스팸 메일함 혹은\n이메일 주소를 다시 한번 확인해주세요"
        : "인증 코드를 다시 입력해주세요"
    }
    
    private func CheckAuthCodeButton() -> some View {
        QPSubButton(
            title: "인증 코드 확인",
            isActive: store.isAuthCodeEnterComplete || store.isLoading,
            variation: .primary,
            tapAction: {
                store.send(.checkAuthCodeButtonTapped)
            }
        )
    }
    
    private func CheckAuthCodeIcon() -> some View {
        Image(.authCodeCheck)
            .resizable()
            .frame(width: 22, height: 22)
    }
}

// MARK: - Preview

#Preview {
    AuthCodeFormView(store: Store(initialState: AuthCodeFormFeature.State(emailText: "test@gmail.com")) {
        AuthCodeFormFeature()
    })
}
