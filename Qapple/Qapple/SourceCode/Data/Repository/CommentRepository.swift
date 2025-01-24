//
//  CommentRepository.swift
//  Qapple
//
//  Created by 문인범 on 1/23/25.
//

import Foundation
import ComposableArchitecture


/**
 Comment API 의존성
 */
struct CommentRepository {
    var fetchBoardCommentList: (_ boardId: Int, _ threshold: Int?) async throws -> ([BoardComment], QappleAPI.PaginationInfo)
    var deleteBoardComment: (_ boardCommentId: Int) async throws -> DeleteBoardCommentsDTO
    var postBoardComment: (_ boardId: Int, _ content: String) async throws -> PostBoardCommentsDTO
    var likeBoardComment: (_ boardCommentId: Int) async throws -> LikeBoardCommentsDTO
    
    
    private static let testComments: [BoardComment] = [
        .init(
            id: 0,
            writeId: 0,
            content: "하이요1",
            heartCount: 1,
            isLiked: false,
            isMine: false,
            isReport: false,
            createdAt: Date().timeAgo,
            anonymityId: -2
        ),
        .init(
            id: 1,
            writeId: 1,
            content: "하이요2",
            heartCount: 2,
            isLiked: true,
            isMine: true,
            isReport: false,
            createdAt: Date().addingTimeInterval(-30).timeAgo,
            anonymityId: -2
        ),
        .init(
            id: 2,
            writeId: 2,
            content: "하이요3",
            heartCount: 3,
            isLiked: false,
            isMine: false,
            isReport: true,
            createdAt: Date().addingTimeInterval(-60*20).timeAgo,
            anonymityId: -2
        ),
        .init(
            id: 3,
            writeId: 3,
            content: "하이요4",
            heartCount: 4,
            isLiked: true,
            isMine: true,
            isReport: false,
            createdAt: Date().addingTimeInterval(-60*60*2).timeAgo,
            anonymityId: -2
        ),
        .init(
            id: 3,
            writeId: 2,
            content: "하이요5",
            heartCount: 4,
            isLiked: true,
            isMine: true,
            isReport: false,
            createdAt: Date().addingTimeInterval(-60*60*2).timeAgo,
            anonymityId: -2
        ),
        .init(
            id: 3,
            writeId: 1,
            content: "하이요6",
            heartCount: 4,
            isLiked: true,
            isMine: true,
            isReport: false,
            createdAt: Date().addingTimeInterval(-60*60*2).timeAgo,
            anonymityId: -2
        ),
    ]
}



extension CommentRepository: DependencyKey {
    static let liveValue: CommentRepository = Self(
        fetchBoardCommentList: { boardId, threshold in
            let url = try QappleAPI.BoardComment.list(boardId: boardId, threshold: threshold, pageSize: 25).url()
            let response: BaseResponse<BoardCommentsDTO> = try await NetworkClient.shared.get(url: url)
            return response.result.toEntityWithThreshold
        },
        deleteBoardComment: { boardCommentId in
            let url = try QappleAPI.BoardComment.delete(commentId: boardCommentId).url()
            let response: BaseResponse<DeleteBoardCommentsDTO> = try await NetworkClient.shared.delete(url: url)
            return response.result
        },
        postBoardComment: { boardId, content in
            let url = try QappleAPI.BoardComment.post(boardId: boardId).url()
            let requestBody: PostBoardCommentsRequest = PostBoardCommentsRequest(comment: content)
            let response: BaseResponse<PostBoardCommentsDTO> = try await NetworkClient.shared.post(url: url, body: requestBody)
            return response.result
        },
        likeBoardComment: { boardCommentId in
            let url = try QappleAPI.BoardComment.like(commentId: boardCommentId).url()
            let requestBody: LikeBoardCommentsRequest = LikeBoardCommentsRequest(commentId: boardCommentId)
            let response: BaseResponse<LikeBoardCommentsDTO> = try await NetworkClient.shared.fetch(url: url, body: requestBody)
            return response.result
        }
    )
    
    static let previewValue: CommentRepository = Self(
        fetchBoardCommentList: { _, _ in
            (testComments, ("", false))
        },
        deleteBoardComment: { _ in
                .init(boardCommentId: 0)
        },
        postBoardComment: { _, _ in
                .init(boardCommentId: 0)
        },
        likeBoardComment: { _ in
                .init(boardCommentId: 0, isLike: true)
        }
    )
}

extension DependencyValues {
    var commentRepository: CommentRepository {
        get { self[CommentRepository.self] }
        set { self[CommentRepository.self] = newValue }
    }
}
