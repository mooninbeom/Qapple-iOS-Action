//
//  NicknameFormView.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import SwiftUI

struct NicknameFormView: View {
    
    @Bindable var store: StoreOf<NicknameFormFeature>
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
            
            Text("사용할 닉네임을 입력해주세요")
                .font(.pretendard(.bold, size: 24))
                .foregroundStyle(.main)
                .padding(.top, 32)
                .padding(.horizontal, 24)
            
            Text("닉네임은 이후에도 변경이 가능해요")
                .font(.pretendard(.medium, size: 16))
                .foregroundStyle(.sub3)
                .lineLimit(2)
                .padding(.top, 12)
                .padding(.horizontal, 24)
            
            QPTextField(
                textString: $store.nicknameText,
                isTextFieldFocused: $isTextFieldFocused,
                title: "닉네임",
                placeholder: "닉네임을 입력해주세요",
                helperText: helperText,
                state: store.isNicknameValidate ? .default : .inValid,
                topTrailingView: {
                    Text("\(store.nicknameText.count)/\(store.nicknameLimit)")
                        .foregroundStyle(TextLabel.ph)
                        .font(.pretendard(.semiBold, size: 14))
                        .frame(height: 8)
                },
                bottomTrailingView: {
                    QPSubButton(
                        title: "중복 검사",
                        isActive: !store.nicknameText.isEmpty && store.isNicknameValidate,
                        variation: .primary,
                        tapAction: {
                            store.send(.checkDuplicateButtonTapped, animation: .bouncy)
                        }
                    )
                }
            )
            .padding(.top, 64)
            .padding(.horizontal, 24)
            .onChange(of: store.nicknameText) { _, value in
                store.send(.typeNicknameText(value))
            }
            
            Spacer()
            
            ActionButton("다음", isActive: store.isNicknameCheckComplete) {
                store.send(.nextButtonTapped)
            }
            .padding(.bottom, 16)
            .padding(.horizontal, 24)
        }
        .background(.first)
        .navigationBarBackButtonHidden()
        .loadingIndicator(isLoading: store.isLoading)
    }
    
    private var helperText: String {
        guard !store.isNicknameCheckComplete else { return "사용 가능한 닉네임이에요" }
        guard !store.isNicknameDuplicate else { return "이미 사용 중인 닉네임이에요" }
        if store.isNicknameValidate { return "* 캐플은 익명 닉네임을 권장해요" }
        else { return "초성, 숫자, 특수문자는 사용할 수 없어요" }
    }
}

// MARK: - Preview

#Preview {
    NicknameFormView(store: Store(initialState: NicknameFormFeature.State(emailText: "")) {
        NicknameFormFeature()
    })
}
