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
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                NavigationBar(
                    title: "프로필 수정",
                    backgroundColor: Background.second,
                    leadingView: {
                        NavigationButton(buttonType: .xmark) {
                            store.send(.backButtonTapped)
                        }
                    },
                    trailingView: {
                        NavigationButton(buttonType: .text("완료", store.nicknameCheck && !store.nicknameChange ? BrandPink.text : TextLabel.sub4)) {
                            store.send(.successButtonTapped)
                        }
                        .disabled(!store.nicknameCheck && !store.nicknameChange) // TODO: 복잡한 로직 개선
                    }
                )
                
                ProfileImageEdit()
                    .padding(.bottom, 32)
                
                WriteNickname(store: store)
                    .padding(.horizontal, 24)
            }
            
            .loadingIndicator(isLoading: store.isLoading)
        }
        .background(Background.second)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .alert($store.scope(state: \.alert, action: \.alert))
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
                    .padding(EdgeInsets(top: 24, leading: 0, bottom: 32, trailing: 0))
            }
            .disabled(true)
            
            Spacer()
        }
    }
}

// MARK: - WriteNickname

private struct WriteNickname: View {
    
    @Bindable var store: StoreOf<ProfileEditFeature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("닉네임")
                .foregroundStyle(TextLabel.sub3)
                .font(Font.pretendard(.medium, size: 14))
                .frame(height: 10)
                .padding(.bottom, 20)
            
            ZStack(alignment: .leading) {
                if store.nickname.isEmpty {
                    Text("닉네임을 입력해주세요")
                        .foregroundStyle(TextLabel.placeholder)
                        .font(Font.pretendard(.semiBold, size: 20))
                        .frame(height: 14)
                }
                
                HStack(spacing: 0) {
                    TextField(text: $store.nickname) {}
                        .foregroundStyle(TextLabel.main)
                        .font(Font.pretendard(.semiBold, size: 20))
                        .frame(height: 14)
                        .autocorrectionDisabled()
                        .onChange(of: store.nickname) { _, nickname in
                            store.send(.nicknameChanged(nickname))
                        }
                    
                    Text("\(store.nickname.count)/\(store.textLimit)")
                        .foregroundStyle(TextLabel.placeholder)
                        .font(Font.pretendard(.semiBold, size: 14))
                        .frame(height: 8)
                }
                .frame(height: 14)
            }
            .padding(.bottom)
            
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(store.nicknameCheck ? GrayScale.wh : (store.nickname.isEmpty ? GrayScale.wh : BrandPink.button))
                .padding(.bottom, 8)
            
            NicknameCheck(store: store)
            
            Spacer()
        }
    }
}

// MARK: - nicknameCheck

private struct NicknameCheck: View {
    
    let store: StoreOf<ProfileEditFeature>
    
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
    
    var body: some View {
        HStack {
            Text(store.nicknameChange ? beforeDescription : afterDescription)
                .font(.pretendard(.semiBold, size: 14))
                .foregroundStyle(store.nicknameFieldAvailable ? TextLabel.sub1 : Context.warning)
            
            Spacer()
            
            if store.nicknameChange {
                Button {
                    store.send(.nicknameCheckButtonTapped)
                } label: {
                    Text("중복 검사")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle((store.nickname.isEmpty || !store.nicknameFieldAvailable) ? TextLabel.sub4 : TextLabel.main)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    (store.nickname.isEmpty || !store.nicknameFieldAvailable) ? GrayScale.secondaryButton : BrandPink.button)
                .cornerRadius(20, corners: .allCorners)
                .disabled(store.nickname.isEmpty ||
                          !store.nicknameFieldAvailable)
            }
        }
    }
}
    
#Preview {
    ProfileEditView(store: Store(initialState: ProfileEditFeature.State(nickname: "simmons", defaultNickname: "simmons")) {
        ProfileEditFeature()
    })
}

