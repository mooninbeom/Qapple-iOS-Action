//
//  CommentFeature.swift
//  Qapple
//
//  Created by 문인범 on 1/21/25.
//

import Foundation
import ComposableArchitecture


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
    }
    
    enum Action {
        case commentViewAppeared
        case paginationCellAppeared
        
        case likeButtonTapped(id: Int)
        case uploadButtonTapped(content: String)
        case deleteButtonTapped(id: Int)
        case reportButtonTapped(id: Int)
        
        case refreshCommentList
        
        case commentTextChanged(text: String)
    }
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .commentViewAppeared, .refreshCommentList:
                return .none
                
            case .paginationCellAppeared:
                return .none
                
            case let .likeButtonTapped(id: id):
                return .none
            case let .uploadButtonTapped(content: content):
                return .none
            case let .deleteButtonTapped(id: id):
                return .none
            case let .reportButtonTapped(id: id):
                return .none
                
            case let .commentTextChanged(text: text):
                state.text = text
                return .none
            }
        }
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
