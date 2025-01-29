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
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 0) {
                    SearchNavigationBar(store: store)
                    
                    SearchBar(store: store)
                        .padding(.horizontal, 16)
                    
                    if !store.searchBoardList.isEmpty {
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

// MARK: - SearchNavigationBar

private struct SearchNavigationBar: View {
    
    let store: StoreOf<BulletinBoardSearchFeature>
    
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
    
    private var searchBoardList: [BulletinBoard] {
        store.searchBoardList.filter { !$0.isReported }
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
                            store.send(.likeBoardButtonTapped(board.id))
                        }
                    )
                    .onAppear {
                        if index == store.searchBoardList.count - 1 && store.hasNext {
                            print("게시판 검색 페이지네이션")
                            store.send(.getSearchBoard)
                        }
                    }
                    .onTapGesture {
                        bulletinBoardStore.send(.postBoardButtonTapped)
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .refreshable {
            store.send(.refreshSearBoard)
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
