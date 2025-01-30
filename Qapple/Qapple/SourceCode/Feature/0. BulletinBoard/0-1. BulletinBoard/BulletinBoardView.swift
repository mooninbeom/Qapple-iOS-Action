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
    @Bindable var store: StoreOf<BulletinBoardFeature>
    
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
                .loadingIndicator(isLoading: store.isLoading)
            }
            .background(Background.first)
        }
        .onAppear{
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
    
    var body: some View {
        VStack(spacing: 0) {
            CustomTabBar(store: store)
            
            AcademyPlanDayCounter(
                academyEvents: store.academyEvents
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

// MARK: - 커스텀 탭바
private struct CustomTabBar: View {
    
    let store: StoreOf<BulletinBoardFeature>
    
    var body: some View {
        NavigationBar(
            title: "게시판",
            trailingView: {
                HStack(spacing: 12) {
                    Spacer()
                    
                    Button {
                        store.send(.notificationButtonTapped)
                    } label: {
                        Image(.noticeIcon)
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(GrayScale.icon)
                            .frame(width: 26 , height: 26)
                    }
                    
                    Button {
                        store.send(.searchButtonTapped)
                    } label: {
                        Image(.search)
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(GrayScale.icon)
                            .frame(width: 26 , height: 26)
                    }
                }
                .padding(.trailing, 8)
            }
        )
    }
}

// MARK: - PostListView

private struct PostListView: View {
    
    @Bindable var store: StoreOf<BulletinBoardFeature>
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(store.bulletinBoardList.enumerated()), id: \.offset) { index, board in
                    BulletinBoardCell(
                        board: board,
                        ellipsis: {
                            store.send(.ellipsisButtonTapped(board.id, board.isMine))
                        },
                        like: {
                            store.send(.likeBoardButtonTapped(board.id))
                        }
                    )
                    .onAppear {
                        if index == store.bulletinBoardList.count - 1
                            && store.hasNext {
                            print("게시판 페이지네이션")
                            store.send(.getBulletinBoardList)
                        }
                    }
                    .onTapGesture {
                        if !board.isReported {
                            store.send(.boardButtonTapped(board))
                        } else {
                            HapticService.notification(type: .warning)
                            store.send(.reportButtonTapped)
                        }
                    }
                    if index != store.bulletinBoardList.endIndex - 1 {
                        QappleDivider()
                    }
                }
            }
        }
        .sheet(item: $store.scope(state: \.sheet?.ellipsisButtonTap, action: \.sheet.ellipsisButtonTap)
        ) { ellipsisStore in
            BulletinBoardEllipsisView(store: ellipsisStore)
                .presentationDetents([.height(84)])
        }
        .alert($store.scope(state: \.alert, action: \.alert))
        .refreshable {
            store.send(.refreshBulletinBoardList)
        }
        .disabled(store.isLoading)
    }
}
