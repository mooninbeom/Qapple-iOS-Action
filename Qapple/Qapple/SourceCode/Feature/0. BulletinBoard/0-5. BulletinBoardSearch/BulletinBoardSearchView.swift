//
//  BulletinBoardSearchView.swift
//  Qapple
//
//  Created by Simmons on 1/29/25.
//

import SwiftUI
import ComposableArchitecture

struct BulletinBoardSearchView: View {
    
    @Bindable var store: StoreOf<BulletinBoardSearchFeature>
    let bulletinBoardStore: StoreOf<BulletinBoardFeature>
    
    @EnvironmentObject private var pathModel: Router
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 0) {
                    NavigationBar(store: store)
                    
                    SearchBar(store: store)
                        .padding(.horizontal, 16)
                    
                    if !bulletinBoardUseCase.state.searchPosts.isEmpty {
                        SearchListView(store: store, bulletinBoardStore: bulletinBoardStore)
                    } else {
                        NoResultView()
                    }
                }
                
                if store.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.primary)
                }
            }
            .background(Background.first)
            .navigationBarBackButtonHidden()
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

// MARK: - NavigationBar

private struct NavigationBar: View {
    
    let store: StoreOf<BulletinBoardSearchFeature>
    
    @EnvironmentObject private var pathModel: Router
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        CustomNavigationBar(
            leadingView: {
                CustomNavigationBackButton(buttonType: .arrow) {
                    store.send(.backButtonTapped)
                }
            },
            principalView: {
                Text("검색하기")
                    .font(Font.pretendard(.semiBold, size: 17))
                    .foregroundStyle(TextLabel.main)
            },
            trailingView: {},
            backgroundColor: Background.first)
    }
}

// MARK: - SearchBar

private struct SearchBar: View {
    
    @Bindable var store: StoreOf<BulletinBoardSearchFeature>
    
    var body: some View {
        HStack(spacing: 6) {
            TextField("검색어를 입력해주세요", text: $store.searchText.sending(\.setSearchText))
                .pretendard(.semiBold, 15)
        }
        .padding(14)
        .background(GrayScale.secondaryButton)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - SearchListView

private struct SearchListView: View {
    
    @Bindable var store: StoreOf<BulletinBoardSearchFeature>
    @Bindable var bulletinBoardStore: StoreOf<BulletinBoardFeature>
    
    @EnvironmentObject private var pathModel: Router
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    
    @State private var selectedPost: Post?
    
    private var searchBoardList: [BulletinBoard] {
        store.searchBoard.filter { !$0.isReported }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(searchBoardList.enumerated()), id: \.offset) { index, board in
                    BulletinBoardCell(
                        board: board,
                        ellipsis: {
                            bulletinBoardStore.send(.ellipsisButtonTapped(board.id, board.isMine))
                        },
                        like: {
                            bulletinBoardStore.send(.likeBoardButtonTapped(board.id))
                        }
                    )
                    .onAppear {
                        if index == store.searchBoard.count - 1 && store.hasNext {
                            print("게시판 검색 페이지네이션")
                            // TODO: 검색 게시글 갱신
                        }
                    }
                    .onTapGesture {
                        // TODO: Navigation처리된 액션 삽입
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .refreshable {
            // TODO: 리프레쉬 넣기
//            bulletinBoardUseCase.effect(.refreshSearchPost(keyword: bulletinBoardUseCase.searchText))
        }
        .sheet(item: $bulletinBoardStore.scope(state: \.sheet?.ellipsisButtonTap, action: \.sheet.ellipsisButtonTap)
        ) { ellipsisStore in
            BulletinBoardEllipsisView(store: ellipsisStore)
                .presentationDetents([.height(84)])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - NoResultView

private struct NoResultView: View {
    var body: some View {
        VStack {
            Text("검색 결과가 없어요")
                .font(Font.pretendard(.medium, size: 14))
                .foregroundStyle(TextLabel.sub4)
                .padding(.top, 24)
            
            Spacer()
        }
    }
}

#Preview {
    BulletinBoardSearchView(store: Store(initialState: BulletinBoardSearchFeature.State()){
        BulletinBoardSearchFeature()
    }, bulletinBoardStore: Store(initialState: BulletinBoardFeature.State()){
        BulletinBoardFeature()
    })
}
