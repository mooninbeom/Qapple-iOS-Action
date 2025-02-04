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
    
    let store: StoreOf<BulletinBoardFeature>
    
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
            store.send(.onAppear)
        }
    }
}

// MARK: - BoardView

private struct BoardView: View {
    
    let store: StoreOf<BulletinBoardFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(
                title: "게시판",
                trailingView: {
                    HStack(spacing: 12) {
                        NavigationButton(buttonType: .image(.noticeIcon)) {
                            store.send(.notificationButtonTapped)
                        }
                        NavigationButton(buttonType: .image(.search)) {
                            store.send(.searchButtonTapped)
                        }
                    }
                    .padding(.trailing, 8)
                }
            )
            
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

// MARK: - PostListView

private struct PostListView: View {
    
    @Bindable var store: StoreOf<BulletinBoardFeature>
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(enumerated(store.bulletinBoardList), id: \.offset) { index, board in
                    BulletinBoardCell(
                        board: board,
                        ellipsis: {
                            store.send(.ellipsisButtonTapped(board.id, board.isMine))
                        },
                        like: {
                            store.send(.likeBoardButtonTapped(board.id))
                        }
                    )
                    .onTapGesture {
                        if !board.isReported {
                            store.send(.boardCellTapped(board))
                        } else {
                            HapticService.notification(type: .warning)
                            store.send(.reportButtonTapped)
                        }
                    }
                    .configurePagination(
                        store.bulletinBoardList,
                        currentIndex: index,
                        hasNext: store.paginationInfo.hasNext,
                        pagination: {
                            store.send(.pagination)
                        }
                    )
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
            store.send(.refresh)
        }
        .disabled(store.isLoading)
    }
}

// MARK: - Preview

#Preview {
    BulletinBoardView(store: Store(initialState: BulletinBoardFeature.State()) {
        BulletinBoardFeature()
    })
}
