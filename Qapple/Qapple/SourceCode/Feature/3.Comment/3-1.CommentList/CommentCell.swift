//
//  CommentCell.swift
//  Qapple
//
//  Created by 문인범 on 1/21/25.
//

import SwiftUI
import ComposableArchitecture


struct CommentCell: View {
    @Bindable var store: StoreOf<CommentFeature>
    
    // TODO: 추후 property 정리 필요
    let comment: CommentEntity
    let cellIndex: Int
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let anchorWidth: CGFloat = 73
    
    @State private var hOffset: CGFloat = 0
    @State private var anchor: CGFloat = 0
    @State private var isCellToggled: Bool = false
    @State private var isDelete: Bool = false
    @State private var isDeleteComplete: Bool = false
    @State private var isReportedComment: Bool = false
    
    var body: some View {
        ZStack {
            if !isReportedComment {
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: 73)
                    
                    content
                        .frame(width: screenWidth)
                    
                    if comment.isMine {
                        deleteBtn
                    } else {
                        reportBtn
                    }
                }
                .offset(x: hOffset)
                .animation(.easeInOut, value: hOffset)
            } else {
                reportCell
            }
        }
        .onAppear {
            if comment.isReport {
                self.isReportedComment = true
            }
        }
    }
    
    private var reportCell: some View {
        HStack {
            Text("신고에 의해 숨김처리 된 댓글입니다.")
                .font(.pretendard(.semiBold, size: 14))
                .foregroundStyle(.sub4)
                .padding(.leading, 16)
            
            Spacer()
            
            Button {
                self.isReportedComment.toggle()
            } label: {
                Text("댓글 보기")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(.text)
            }
            .padding(.trailing, 27)
        }
        .frame(width: screenWidth, height: 56.03)
        .opacity(0.5)
    }
    
    private var drag: some Gesture {
        DragGesture(minimumDistance: 50)
            .onChanged { value in
                let transWidth = value.translation.width

                hOffset = anchor + transWidth

                if anchor < 0 {
                    isCellToggled = hOffset < -screenWidth / 3 + screenWidth / 15
                } else {
                    isCellToggled = hOffset < -screenWidth / 15
                }
            }
            .onEnded { value in
                if isCellToggled {
                    anchor = -anchorWidth
                } else {
                    anchor = 0
                }
                hOffset = anchor
            }
    }
    
    private var content: some View {
        HStack(alignment: .top, spacing: 13) {
            // 사용자 이미지
            Image(.profileDummy)
                .resizable()
                .scaledToFit()
                .frame(width: 28)
                .padding(.top, 16)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 10) {
                    // 사용자 이름
                    if self.comment.writerId == -1 {
                        Text("작성자")
                            .font(.pretendard(.semiBold, size: 14))
                            .foregroundStyle(.text)
                    } else {
                        Text("러너 \(self.comment.writerId)")
                            .font(.pretendard(.semiBold, size: 14))
                            .foregroundStyle(.icon)
                    }
                    
                    // 댓글 timestamp
                    Text(comment.createdAt.ISO8601ToDate.timeAgo)
                        .font(.pretendard(.light, size: 12))
                        .foregroundStyle(.disable)
                }
                
                // 댓글 내용
                Text(comment.content)
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(.main)
            }
            .padding(.vertical, 16)

            
            Spacer()
            
            
            VStack {
                // 댓글 좋아요 버튼
                Button {
                    if !comment.isReport {
                        Task {
                            if !comment.isLiked { HapticService.impact(style: .light) }
                            store.send(.likeButtonTapped(id: comment.id))
                        }
                    } else {
                        self.isReportedComment.toggle()
                    }
                } label: {
                    if !comment.isReport {
                        VStack {
                            Image(systemName: comment.isLiked ? "heart.fill" : "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16)
                                .foregroundStyle(comment.isLiked ? .button : .sub4)
                            
                            // 댓글 좋아요 갯수
                            if comment.heartCount != 0 {
                                Text("\(comment.heartCount)")
                                    .font(.pretendard(.medium, size: 14))
                                    .foregroundStyle(.sub3)
                            }
                        }
                    } else {
                        Text("댓글 숨기기")
                            .font(.pretendard(.medium, size: 14))
                            .foregroundStyle(.text)
                    }
                }
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, 16)
        .background(Color.bk)
        .gesture(drag, isEnabled: !comment.isReport)
    }
    
    private var deleteBtn: some View {
        Button {
            store.send(.deleteButtonTapped(id: self.comment.id))
            HapticService.notification(type: .error)
        } label: {
            ZStack {
                Color.delete
                
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundStyle(Color.wh)
            }
        }
        .frame(width: 73)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
    
    private var reportBtn: some View {
        Button {
            // TODO: 네비게이션 연결 필요
            store.send(.reportButtonTapped(id: self.comment.id))
        } label: {
            ZStack {
                Color.report
                
                Image(systemName: "light.beacon.min")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.wh)
            }
        }
        .frame(width: 73)
    }
}


#Preview {
    var store = StoreOf<CommentFeature>(initialState: CommentFeature.State()) {
        CommentFeature()
    }
    
    let comment = CommentEntity(
        id: 4,
        writerId: 5,
        content: "테스트입니다",
        createdAt: "2025-01-01T00:00:00Z",
        heartCount: 20,
        isLiked: false,
        isMine: true,
        isReport: false)
    
    CommentCell(store: store, comment: comment, cellIndex: 1)
}
