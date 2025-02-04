//
//  ProfileView.swift
//  Qapple
//
//  Created by Simmons on 1/30/25.
//

import SwiftUI
import MessageUI
import ComposableArchitecture

struct ProfileView: View {
    
    @Bindable var store: StoreOf<ProfileFeature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationBar(
                title: "프로필",
                backgroundColor: .second
            )
            
            ProfileSummary(store: store)
                .padding(.bottom, 24)
            
            ProfileList(store: store)
                .padding(.horizontal, 24)
            
            BottomSection()
                .padding(.top, 24)
                .padding(.horizontal, 24)
            
            Spacer()
        }
        .background(.first)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .loadingIndicator(isLoading: store.isLoading)
        .onAppear {
            store.send(.getProfile)
        }
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

// MARK: - ProfileSummary

private struct ProfileSummary: View {
    
    let store: StoreOf<ProfileFeature>
    
    var body: some View {
        HStack(spacing: 16) {
            Image(.cappleDefaultProfile)
                .resizable()
                .frame(width: 72, height: 72)
                .background(.white)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 16) {
                
                HStack(spacing: 6) {
                    Text("\(store.nickname)")
                        .foregroundStyle(.main)
                        .font(.pretendard(.bold, size: 20))
                        .frame(height: 14)
                    
                    Button {
                        store.send(.editProfileButtonTapped)
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.icon)
                    }
                }
                
                Text("\(store.joinDate)")
                    .foregroundStyle(.sub3)
                    .font(Font.pretendard(.semiBold, size: 14))
                    .frame(height: 10)
            }
            .frame(height: 40)
            
            Spacer()
        }
        .padding(24)
        .background(Background.second)
    }
}

// MARK: - ProfileList

private struct ProfileList: View {
    
    let store: StoreOf<ProfileFeature>
    
    var body: some View {
        VStack(spacing: 48) {
            QuestionAnswerSection(store: store)
            InquiriesReportsSection(store: store)
            AccountSection(store: store)
        }
    }
}

// MARK: - QuestionAnswerSection

private struct QuestionAnswerSection: View {
    
    let store: StoreOf<ProfileFeature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ProfileListTitle(title: "질문/답변")
                .padding(.bottom, 12)
            
            ProfileListCell(
                title: "내 답변",
                icon: .writeAnswerIcon,
                tapAction: {
                    store.send(.myAnswerListButtonTapped)
                }
            )
        }
    }
}

// MARK: - InquiriesReportsSection

private struct InquiriesReportsSection: View {
    
    @Bindable var store: StoreOf<ProfileFeature>
    
    @State private var mailResult: Result<MFMailComposeResult, Error>?
    @State private var isShowingMailView = false
    @State private var isEmailDisabledAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ProfileListTitle(title: "문의 및 제보")
                .padding(.bottom, 12)
            
            ProfileListCell(
                title: "문의하기",
                icon: .inquiryIcon,
                tapAction: {
                    store.send(.inquiryButtonTapped)
                }
            )
            
            ProfileListCell(
                title: "캐플을 만든 사람들",
                icon: .peopleWhoMadeQappleIcon,
                tapAction: {
                    store.send(.peopleWhoMadeQappleButtonTapped)
                }
            )
        }
        .sheet(item: $store.scope(
            state: \.sheet?.inquiryButtonTap,
            action: \.sheet.inquiryButtonTap
        )) { _ in
            MailService.makeMailView(result: $mailResult)
        }
    }
}

// MARK: - AccountSection

private struct AccountSection: View {
    
    let store: StoreOf<ProfileFeature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ProfileListTitle(title: "계정 관리")
                .padding(.bottom, 12)
            
            ProfileListCell(
                title: "로그아웃",
                icon: .signOutIcon,
                tapAction: {
                    store.send(.logOutButtonTapped)
                    HapticService.notification(type: .warning)
                }
            )
            
            ProfileListCell(
                title: "회원탈퇴",
                icon: .resign,
                isDistructive: true,
                tapAction: {
                    store.send(.resignButtonTapped)
                    HapticService.notification(type: .warning)
                }
            )
        }
    }
}

// MARK: - BottomSection

private struct BottomSection: View {
    
    private var appVersion: String {
        VersionService.deviceAppVersion
    }
    
    var body: some View {
        Text("앱 버전 \(appVersion)")
            .pretendard(.regular, 15)
            .foregroundStyle(.disable)
    }
}

// MARK: - Preview

#Preview {
    ProfileView(store: Store(initialState: ProfileFeature.State()) {
        ProfileFeature()
    })
}
