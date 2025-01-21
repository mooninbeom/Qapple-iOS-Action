//
//  CommentView.swift
//  Qapple
//
//  Created by 문인범 on 1/21/25.
//

import SwiftUI
import ComposableArchitecture

struct CommentView: View {
    @Bindable var store: StoreOf<CommentFeature> = .init(initialState: CommentFeature.State()) {
        CommentFeature()
    }
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            
            BulletinBoardCell(
                post: store.post,
                seeMoreAction: {
                    // TODO: 추후 수정 필요
                })
            .frame(width: UIScreen.main.bounds.width)
            .disabled(store.isLoading)
            
            commentList
            
            Spacer()
            
            addComment
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
        // MARK: - Post ellipsis 버튼
//        .sheet(item: $selectedPost) { post in
//            BulletinBoardSeeMoreSheetView(
//                sheetType: post.isMine ? .mine : .others,
//                post: post,
//                isComment: true
//            )
//            .presentationDetents([.height(84)])
//            .presentationDragIndicator(.visible)
//        }
        .onReceive(NotificationCenter.default.publisher(for: .updateViewNotification)) { _ in
            store.send(.refreshCommentList)
        }
        // MARK: - 게시글 에러 대응 alert
//        .alert("게시글이 삭제됐거나 오류가 발생했습니다.", isPresented: $commentViewModel.isPostDeletedAlertPresented) {
//            Button("확인", role: .none) {
//                
//            }
//        }
    }
    
    var commentList: some View {
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
    
    // 댓글 작성 View
    var addComment: some View {
        HStack(alignment: .bottom) {
            TextField("댓글 추가", text: $store.text.sending(\.commentTextChanged), axis: .vertical)
                .font(.pretendard(.regular, size: 17))
                .lineLimit(...3)
                .padding(.horizontal)
                .padding(.vertical, 12)
            
            Button {
                Task.init {
                    HapticService.notification(type: .success)
                    store.send(.uploadButtonTapped(content: ""))
                }
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
    
    
    private var seperator: some View {
        Rectangle()
            .foregroundStyle(Color.placeholder)
            .frame(height: 1)
    }
}


private struct HeaderView: View {
    
    @EnvironmentObject private var pathModel: Router
    
    var body: some View {
        CustomNavigationBar(
            leadingView: {
                CustomNavigationBackButton(buttonType: .arrow) {
                    // TODO: 네비게이션 수정 필요
                }
            },
            principalView: {
                Text("댓글")
                    .font(.pretendard(.semiBold, size: 17))
            },
            trailingView: {},
            backgroundColor: Color.Background.first)
    }
}

