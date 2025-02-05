//
//  CommentView.swift
//  Qapple
//
//  Created by 문인범 on 1/21/25.
//

import SwiftUI
import ComposableArchitecture

struct CommentView: View {
    @Bindable var store: StoreOf<CommentFeature>
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            
            BulletinBoardCell(
                board: store.board,
                seeMore: {
                    store.send(.seeMoreAction)
                },
                like: {
                    store.send(.likeBoardButtonTapped)
                }
            )
            .frame(width: UIScreen.main.bounds.width)
            .disabled(store.isLoading)
            
            CommentListView(store: store)
            
            Spacer()
            
            AddCommentView(store: store)
                .frame(width: screenWidth)
                .padding(.bottom, 8)

        }
        .background(Color.bk)
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarBackButtonHidden()
        .task {
            store.send(.commentViewAppeared)
        }
        .alert($store.scope(state: \.alert, action: \.alert))
        .sheet(item: $store.scope(state: \.sheet, action: \.sheet)
        ) { store in
            switch store.case {
            case let .seeMore(store): SeeMoreSheet(store: store)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .updateViewNotification)) { _ in
            store.send(.refreshCommentList)
        }
    }
    
    private var seperator: some View {
        Rectangle()
            .foregroundStyle(Color.placeholder)
            .frame(height: 1)
    }
}

/**
 상단 네비게이션 View
 */
private struct HeaderView: View {
    var body: some View {
        NavigationBar(
            title: "댓글",
            leadingView: {
                NavigationButton(buttonType: .back) {
                    // TODO: 네비게이션 수정 필요
                }
            }
        )
    }
}

/**
 댓글 리스트 View
 */
private struct CommentListView: View {
    @Bindable var store: StoreOf<CommentFeature>
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    // 데이터 연결
                    ForEach(Array(self.store.comments.enumerated()), id: \.offset) { index, comment in
                        CommentCell(
                            store: self.store,
                            comment: comment,
                            cellIndex: index
                        )
                        .onAppear {
                            store.send(.paginationCellAppeared)
                        }
                    }
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .background(Color.bk)
            .refreshable {
                store.send(.refreshCommentList)
            }
            
            if store.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            }
            
            if store.comments.isEmpty && !store.isLoading {
                VStack {
                    Text("아직 작성된 댓글이 없습니다")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(.sub5)
                        .multilineTextAlignment(.center)
                        .padding(.top, 24)
                    
                    Spacer()
                }
            }
        }
    }
}



/**
 댓글 작성 View
 */
private struct AddCommentView: View {
    @Bindable var store: StoreOf<CommentFeature>
    
    var body: some View {
        HStack(alignment: .bottom) {
            TextField("댓글 추가", text: $store.text.sending(\.commentTextChanged), axis: .vertical)
                .font(.pretendard(.regular, size: 17))
                .lineLimit(...3)
                .padding(.horizontal)
                .padding(.vertical, 12)
            
            Button {
                    HapticService.notification(type: .success)
                    store.send(.uploadButtonTapped)
            } label: {
                Image(systemName: "paperplane")
                    .font(.system(size: 20))
            }
            .tint(Color.wh)
            .padding(.trailing, 12)
            .padding(.bottom, 12)
            .disabled(store.text.isEmpty || store.isLoading )
        }
        .background {
            RoundedRectangle(cornerRadius: 11)
                .foregroundStyle(Color.placeholder)
        }
        .frame(minHeight: 50)
        .padding(.horizontal, 16)
    }
}


#Preview {
    CommentView(
        store: Store(
            initialState: CommentFeature.State(
                board: BulletinBoard(
                    id: 1,
                    writerId: 1,
                    writerNickname: "이호창",
                    content: "특전사",
                    heartCount: 10,
                    commentCount: 13,
                    createAt: .init(),
                    isMine: false,
                    isReported: false,
                    isLiked: true
                )
            )
        ){
        CommentFeature()
    })
}
