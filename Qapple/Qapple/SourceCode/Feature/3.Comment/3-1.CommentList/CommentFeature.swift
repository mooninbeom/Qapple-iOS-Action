//
//  CommentFeature.swift
//  Qapple
//
//  Created by 문인범 on 1/21/25.
//

import Foundation
import ComposableArchitecture

/**
 게시판 댓글(CommentView) Reducer
 */
@Reducer
struct CommentFeature {
    @ObservableState
    struct State: Equatable {
        var post: Post = samplePost
        
        var text: String = ""
        
        var comments: [CommentEntity] = []
        
        var postWriterId: Int = -1
        
        var scrollIndex: Int?
        var isLoading: Bool = false
        
        var threshold: Int?
        var hasNext: Bool = false
        
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action: Equatable {
        case commentViewAppeared
        case paginationCellAppeared
        
        case likeButtonTapped(id: Int)
        case uploadButtonTapped
        case deleteButtonTapped(id: Int)
        case reportButtonTapped(id: Int)
        
        case refreshCommentList
        
        case commentTextChanged(text: String)
        
        case alert(PresentationAction<Alert>)
        
        @CasePathable
        enum Alert: Equatable {
            case boardLoadError
            case deleteComment(Int)
        }
    }
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .commentViewAppeared, .refreshCommentList:
                // TODO: 데이터 fetch, 게시글 에러 대응(AlertState)
                return .none
                
            case .paginationCellAppeared:
                return .none
                
            case .likeButtonTapped(id: _):
                return .none
            case .uploadButtonTapped:
                // 댓글 업로드(state.text 사용)
                return .none
                
            case let .commentTextChanged(text: text):
                state.text = text
                return .none
            
            case .reportButtonTapped(id: _):
                // TODO: CommentReportView로 navigating
                return .none
                
            // Delete 버튼 alert
            case let .deleteButtonTapped(id: id):
                state.alert = AlertState {
                    TextState("정말로 댓글을 삭제하시겠습니까?")
                } actions: {
                    ButtonState(role: .destructive, action: .deleteComment(id), label: { TextState("삭제") })
                    ButtonState(role: .cancel, label: { TextState("취소") })
                }
                return .none
                
            case let .alert(.presented(.deleteComment(id))):
                // TODO: 댓글 삭제 구현
                print("댓글 아이디: \(id) 삭제")
                
                state.alert = AlertState {
                    TextState("댓글이 삭제되었습니다")
                } actions: {
                    ButtonState(label: { TextState("확인")})
                }
                return .none
                
            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}



extension CommentFeature {
    // 이름을 익명화 해주는 method
    private func anonymizeComment(id: Int, comments: [CommentEntity]) -> [CommentEntity] {
        var anonymousArray: [Int: Int] = [:]
        var anonymousIndex: Int = 0
        
        let result = comments.map { comment in
            
            // 한번이라도 나온 writer인지 여부 판단
            let isContainName = anonymousArray.values.contains {
                $0 == comment.writerId
            }
            
            if !isContainName { // 처음 나오는 writer일 경우
                anonymousIndex += 1
                
                if comment.writerId == id {
                    anonymousArray.updateValue(comment.writerId, forKey: -1)
                } else {
                    anonymousArray.updateValue(comment.writerId, forKey: anonymousIndex)
                }
                
                return CommentEntity(
                    id: comment.id,
                    writerId: (comment.writerId == id) ? -1 : anonymousIndex,
                    content: comment.content,
                    createdAt: comment.createdAt,
                    heartCount: comment.heartCount,
                    isLiked: comment.isLiked,
                    isMine: comment.isMine,
                    isReport: comment.isReport
                )
            } else { // 한번 이상 나온 writer일 경우
                // 해당 value의 key 값을 찾아 name의 index로 제공
                let currentIndex = anonymousArray
                    .filter { $0.value == comment.writerId }
                    .first!.key
                
                return CommentEntity(
                    id: comment.id,
                    writerId: currentIndex,
                    content: comment.content,
                    createdAt: comment.createdAt,
                    heartCount: comment.heartCount,
                    isLiked: comment.isLiked,
                    isMine: comment.isMine,
                    isReport: comment.isReport
                )
            }
        }
        
        return result
    }
}



private let samplePost = Post(
    boardId: 1,
    writerId: 1,
    writerNickname: "이호창",
    content: "특전사",
    heartCount: 10,
    commentCount: 13,
    createAt: .init(),
    isMine: false,
    isReported: false,
    isLiked: true)
