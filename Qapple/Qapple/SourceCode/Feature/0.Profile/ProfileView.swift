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
    
    let store: StoreOf<ProfileFeature>
    
    @EnvironmentObject private var pathModel: Router
    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject private var viewModel = MyPageViewModel()
    
    var body: some View {
        ZStack {
            Color(Background.first)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                NavigationBar(
                    title: "프로필",
                    backgroundColor: Background.second
                )
                
                ProfileSummary(store: store)
                    .padding(.bottom, 24)
                
                MyPageList()
                    .padding(.horizontal, 24)
                
                BottomSection()
                    .padding(.top, 24)
                    .padding(.horizontal, 24)
                
                Spacer()
            }
            .environmentObject(viewModel)
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await viewModel.requestMyPageInfo()
                }
            }
            .loadingIndicator(isLoading: store.isLoading)
        }
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
                .background(Color.white)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 16) {
                
                HStack(spacing: 6) {
                    Text("\(store.nickname)")
                        .foregroundStyle(TextLabel.main)
                        .font(Font.pretendard(.bold, size: 20))
                        .frame(height: 14)
                    
                    Button {
                        store.send(.editProfileButtonTapped)
//                        pathModel.pushView(
//                            screen: MyProfilePathType.profileEdit(nickname: viewModel.myPageInfo.nickname)
//                        )
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(GrayScale.icon)
                    }
                }
                
                Text("\(store.joinDate)")
                    .foregroundStyle(TextLabel.sub3)
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

// MARK: - MyPageList

private struct MyPageList: View {
    var body: some View {
        VStack(spacing: 48) {
            QuestionAnswerSection()
            InquiriesReportsSection()
            AccountSection()
        }
    }
}

// MARK: - QuestionAnswerSection

private struct QuestionAnswerSection: View {
    
    @EnvironmentObject private var pathModel: Router
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MyPageSectionTitle(title: "질문/답변")
                .padding(.bottom, 12)
            
            MyPageSectionCell(
                title: "내 답변",
                icon: .writeAnswerIcon,
                tapAction: {
                    pathModel.pushView(screen: MyProfilePathType.writtenAnswer)
                }
            )
        }
    }
}

// MARK: - InquiriesReportsSection

private struct InquiriesReportsSection: View {
    
    @EnvironmentObject private var pathModel: Router
    
    @State private var mailResult: Result<MFMailComposeResult, Error>?
    @State private var isShowingMailView = false
    @State private var isEmailDisabledAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MyPageSectionTitle(title: "문의 및 제보")
                .padding(.bottom, 12)
            
            MyPageSectionCell(
                title: "문의하기",
                icon: .inquiryIcon,
                tapAction: {
                    if !MFMailComposeViewController.canSendMail() {
                        isEmailDisabledAlert.toggle()
                    } else {
                        isShowingMailView.toggle()
                    }
                }
            )
        }
        .alert("메일 앱에 로그인할 수 없어요", isPresented: $isEmailDisabledAlert) {
            Button("확인", role: .none, action: {})
        } message: {
            Text("메일 앱에 로그인하거나\n공식 메일 주소로 문의주세요\n(0.team.capple@gmail.com)")
        }
        .sheet(isPresented: $isShowingMailView) {
            MailService.makeMailView(result: $mailResult)
        }
    }
}

// MARK: - AccountSection

private struct AccountSection: View {
    
    @EnvironmentObject private var pathModel: Router
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var viewModel: MyPageViewModel
    
    @State private var isLogOutAlertPresented = false
    @State private var isResignAlertPresented = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MyPageSectionTitle(title: "계정 관리")
                .padding(.bottom, 12)
            
            MyPageSectionCell(
                title: "로그아웃",
                icon: .signOutIcon,
                tapAction: {
                    isLogOutAlertPresented.toggle()
                    HapticService.notification(type: .warning)
                }
            )
            
            MyPageSectionCell(
                title: "회원탈퇴",
                icon: .resign,
                isDistructive: true,
                tapAction: {
                    isResignAlertPresented.toggle()
                    HapticService.notification(type: .warning)
                }
            )
        }
        .alert("로그아웃 할까요?", isPresented: $isLogOutAlertPresented) {
            HStack {
                Button("취소", role: .cancel, action: {})
                Button("로그아웃", role: .none, action: {
                    pathModel.popToRoot()
                    authViewModel.isSignIn = false
                    viewModel.signOut()
                })
            }
        } message: {
            Text("언제든 다시 돌아올 수 있습니다!")
        }
        .alert("정말 탈퇴하시겠어요?", isPresented: $isResignAlertPresented) {
            HStack {
                Button("취소", role: .cancel, action: {})
                Button("회원 탈퇴", role: .destructive, action: {
                    viewModel.requestDeleteMember()
                    pathModel.popToRoot()
                    authViewModel.isSignIn = false
                    authViewModel.isSignUp = false
                })
            }
        } message: {
            Text("탈퇴하면 계정은 복구되지 않아요\n단, 이미 작성한 답변은 남아있어요")
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
            .foregroundStyle(TextLabel.disable)
    }
}

// MARK: - Preview

#Preview {
    ProfileView(store: Store(initialState: ProfileFeature.State()) {
        ProfileFeature()
    })
}

