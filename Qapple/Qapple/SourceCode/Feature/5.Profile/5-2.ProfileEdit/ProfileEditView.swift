//
//  ProfileEditView.swift
//  Qapple
//
//  Created by Simmons on 2/1/25.
//

import SwiftUI
import ComposableArchitecture

struct ProfileEditView: View {
    
    @Bindable var store: StoreOf<ProfileEditFeature>
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationBar(
                title: "프로필 수정",
                backgroundColor: .second,
                leadingView: {
                    NavigationButton(buttonType: .back) {
                        store.send(.backButtonTapped)
                    }
                },
                trailingView: {
                    NavigationButton(buttonType: .text("완료", store.nicknameCheck && !store.nicknameChange ? .text : .sub4)) {
                        store.send(.successButtonTapped)
                    }
                    .disabled(store.nicknameCheck && store.nicknameChange)
                }
            )
            
            ProfileImageEdit()
                .padding(.top, 24)
            
            QPTextField(
                textString: $store.nickname,
                isTextFieldFocused: $isTextFieldFocused,
                title: "닉네임",
                placeholder: store.defaultNickname,
                helperText: store.nicknameChange ? beforeDescription : afterDescription,
                state: store.nicknameFieldAvailable ? .default : .inValid,
                bottomTrailingView: {
                    QPSubButton(
                        title: "중복 검사",
                        isActive: !store.nickname.isEmpty && store.nicknameFieldAvailable,
                        variation: .primary,
                        tapAction: {
                            store.send(.nicknameCheckButtonTapped)
                        }
                    )
                }
            )
            .padding(.top, 32)
            .padding(.horizontal, 24)
            .onChange(of: store.nickname) { _, nickname in
                store.send(.nicknameChanged(nickname))
            }
            
            Spacer()
        }
        .background(.second)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .loadingIndicator(isLoading: store.isLoading)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
    
    /// 중복 검사 전 설명 문자입니다.
    private var beforeDescription: String {
        if store.nicknameFieldAvailable {
            return "* 캐플은 익명 닉네임을 권장해요"
        } else {
            return "초성, 숫자, 특수문자는 사용할 수 없어요"
        }
    }
    
    /// 중복 검사 후 설명 문자입니다.
    private var afterDescription: String {
        if store.nicknameCheck {
            return "사용 가능한 닉네임이에요"
        } else {
            return "이미 사용 중인 닉네임이에요"
        }
    }
}

// MARK: - ProfileImageEdit

private struct ProfileImageEdit: View {
    var body: some View {
        HStack {
            Spacer()
            
            Button {
                // TODO: 이미지 변경
            } label: {
                Image(.profileDummy)
                    .resizable()
                    .frame(width: 72, height: 72)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .disabled(true)
            
            Spacer()
        }
    }
}

// MARK: - Preview
    
#Preview {
    ProfileEditView(store: Store(initialState: ProfileEditFeature.State(nickname: "simmons", defaultNickname: "simmons")) {
        ProfileEditFeature()
    })
}
