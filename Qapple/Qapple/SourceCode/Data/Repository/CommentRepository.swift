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
    var postBoardComment: (_ boardId: Int, _ content: String) async throws -> Void
    var likeBoardComment: (_ boardCommentId: Int) async throws -> Void
    
    
    private static let testComments: [BoardComment] = [
        .init(
            id: 0,
            writeId: 0,
            content: "하이요1",
            heartCount: 1,
            isLiked: false,
            isMine: false,
            isReport: false,
            createdAt: .now,
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
            createdAt: Date().addingTimeInterval(-30),
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
            createdAt: Date().addingTimeInterval(-60*20),
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
            createdAt: Date().addingTimeInterval(-60*60*2),
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
            createdAt: Date().addingTimeInterval(-60*60*2),
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
            createdAt: Date().addingTimeInterval(-60*60*2),
            anonymityId: -2
        ),
    ]
}



extension CommentRepository: DependencyKey {
    static let liveValue: CommentRepository = Self(
        fetchBoardCommentList: { boardId, threshold in
            let url = try QappleAPI.BoardComment.list(boardId: boardId, threshold: threshold, pageSize: 25).url()
            let response: BaseResponse<BoardCommentsDTO> = try await NetworkService.shared.get(url: url)
            return response.result.toEntityWithThreshold
        },
        deleteBoardComment: { boardCommentId in
            let url = try QappleAPI.BoardComment.delete(commentId: boardCommentId).url()
            let response: BaseResponse<DeleteBoardCommentsDTO> = try await NetworkService.shared.delete(url: url)
            return response.result
        },
        postBoardComment: { boardId, content in
            let url = try QappleAPI.BoardComment.post(boardId: boardId).url()
            let requestBody: PostBoardCommentsRequest = PostBoardCommentsRequest(comment: content)
            let response: BaseResponse<PostBoardCommentsDTO> = try await NetworkService.shared.post(url: url, body: requestBody)
        },
        likeBoardComment: { boardCommentId in
            let url = try QappleAPI.BoardComment.like(commentId: boardCommentId).url()
            let requestBody: LikeBoardCommentsRequest = LikeBoardCommentsRequest(commentId: boardCommentId)
            let response: BaseResponse<LikeBoardCommentsDTO> = try await NetworkService.shared.patch(url: url, body: requestBody)
        }
    )
    
    static let previewValue: CommentRepository = Self(
        fetchBoardCommentList: { _, _ in
            (testComments, .init(threshold: "", hasNext: false))
        },
        deleteBoardComment: { _ in
                .init(boardCommentId: 0)
        },
        postBoardComment: { boardId, content in
                print("\(boardId)게시글에 \(content)글을 작성했습니다.")
        },
        likeBoardComment: { commentId in
            print("게시글에 좋아요를 눌렀습니다: \(commentId)")
        }
    )
}

extension DependencyValues {
    var commentRepository: CommentRepository {
        get { self[CommentRepository.self] }
        set { self[CommentRepository.self] = newValue }
    }
}
