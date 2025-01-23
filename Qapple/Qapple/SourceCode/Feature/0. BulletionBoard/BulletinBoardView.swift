//
//  BulletinBoardView.swift
//  Qapple
//
//  Created by Simmons on 1/23/25.
//

import SwiftUI
import ComposableArchitecture

// MARK: - BulletinBoardView

struct BulletinBoardView: View {
    @Binding var store: StoreOf<BulletinBoardFeature>
    
    @EnvironmentObject private var pathModel: Router
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                BoardView(store: store)
                
                NewPostButton(
                    title: "게시글 작성",
                    tapAction: {
                        store.send(.postBoardButtonTapped)
                    }
                )
                .position(
                    CGPoint(
                        x: proxy.size.width / 2,
                        y: proxy.size.height - 40
                    )
                )
                
                if store.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.primary)
                }
            }
            .background(Background.first)
        }
        .onAppear{
            bulletinBoardUseCase.isClickComment = false // ?
            bulletinBoardUseCase.state.searchPosts.removeAll() // 어떻게 처리할 지 고민
            bulletinBoardUseCase.searchText = "" // 이것도
            store.send(.getBulletinBoardList)
            
        }
        .onReceive(NotificationCenter.default.publisher(for: .updateViewNotification)) { _ in
            store.send(.refreshBulletinBoardList)
        }
    }
}

// MARK: - BoardView

private struct BoardView: View {
    
    @Bindable var store: StoreOf<BulletinBoardFeature>
    
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar()
            
            AcademyPlanDayCounter(
                academyEvents: bulletinBoardUseCase.state.academyEvents
            )
            .padding(.top, 8)
            .padding(.horizontal, 16)
            
            PostListView(store: store)
                .padding(.top, 20)
            
            Spacer()
                .frame(height: 2)
        }
    }
}

// MARK: - NavigationBar

private struct NavigationBar: View {
    @EnvironmentObject private var pathModel: Router
    
    var body: some View {
        CustomTabBar()
    }
}

// MARK: - 커스텀 탭바
private struct CustomTabBar: View {
    
    @EnvironmentObject var pathModel: Router
    
    var body: some View {
        CustomNavigationBar(
            leadingView: {},
            principalView: {
                Text("게시판")
                    .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main)
            },
            trailingView: {
                HStack(spacing: 12) {
                    Spacer()
                    
                    Button {
                        pathModel.pushView(screen: BulletinBoardPathType.alert)
                    } label: {
                        Image(.noticeIcon)
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(GrayScale.icon)
                            .frame(width: 26 , height: 26)
                    }
                    
                    Button {
                        pathModel.pushView(screen: BulletinBoardPathType.search)
                    } label: {
                        Image(.search)
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(GrayScale.icon)
                            .frame(width: 26 , height: 26)
                    }
                }
                .padding(.trailing, 8)
            },
            backgroundColor: Background.first)
    }
}

// MARK: - PostListView

private struct PostListView: View {
    
    @Bindable var store: StoreOf<BulletinBoardFeature>
    
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    
    @EnvironmentObject private var pathModel: Router
    
    @State private var selectedPost: Post?
    @State private var isReportedPostTappedAlert = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(bulletinBoardUseCase.state.posts.enumerated()), id: \.offset) { index, post in
                    BulletinBoardCell(
                        post: post,
                        seeMoreAction: {
                            selectedPost = post
                        }
                    )
                    .onAppear {
                        if index == bulletinBoardUseCase.state.posts.count - 1
                            && bulletinBoardUseCase.state.hasNext {
                            print("게시판 페이지네이션")
                            store.send(.getBulletinBoardList)
                        }
                    }
                    .onTapGesture {
                        if !post.isReported {
                            pathModel.pushView(screen: BulletinBoardPathType.comment(post: post))
                            bulletinBoardUseCase.isClickComment = true
                        } else {
                            HapticService.notification(type: .warning)
                            isReportedPostTappedAlert.toggle()
                        }
                    }
                    
                    if index != bulletinBoardUseCase.state.posts.endIndex - 1 {
                        QappleDivider()
                    }
                }
            }
        }
        .refreshable {
            store.send(.refreshBulletinBoardList)
        }
        .disabled(store.isLoading)
        .sheet(item: $selectedPost) { post in
            BulletinBoardSeeMoreSheetView(
                sheetType: post.isMine ? .mine : .others,
                post: post,
                isComment: false
            )
            .presentationDetents([.height(84)])
            .presentationDragIndicator(.visible)
        }
        .alert("신고된 게시글", isPresented: $isReportedPostTappedAlert) {
            Button("확인", role: .none, action: {})
        } message: {
            Text("신고된 게시글은 열람할 수 없습니다.")
        }
    }
}
