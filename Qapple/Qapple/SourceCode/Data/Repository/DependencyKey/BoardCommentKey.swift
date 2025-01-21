//
//  BoardCommentKey.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

extension QappleRepository {
    
    static func makeFetchBoardCommentList() -> (_ boardId: Int, _ threshold: Int?) async throws -> ([BoardComment], QappleAPI.PaginationInfo) {
        return { boardId, threshold in
            let url = try QappleAPI.BoardComment.list(boardId: boardId, threshold: threshold, pageSize: 10).url()
            let response: BaseResponse<BoardCommentsDTO> = try await networkClient.get(url: url)
            return response.result.toEntityWithThreshold
        }
    }
    
    static func makeDeleteBoardComment() -> (_ commentId: Int) async throws -> DeleteBoardCommentsDTO {
        return { commentId in
            let url = try QappleAPI.BoardComment.delete(commentId: commentId).url()
            let response: BaseResponse<DeleteBoardCommentsDTO> = try await networkClient.delete(url: url)
            return response.result
        }
    }
    
    static func makePostBoardComment() -> (_ boardId: Int, _ comment: String) async throws -> PostBoardCommentsDTO {
        return { boardId, comment in
            let url = try QappleAPI.BoardComment.post(boardId: boardId).url()
            let requestBody: PostBoardCommentsRequest = PostBoardCommentsRequest(comment: comment)
            let response: BaseResponse<PostBoardCommentsDTO> = try await networkClient.post(url: url, body: requestBody)
            return response.result
        }
    }
    
    static func makeLikeBoardComment() -> (_ commentId: Int) async throws -> LikeBoardCommentsDTO {
        return { commentId in
            let url = try QappleAPI.BoardComment.like(commentId: commentId).url()
            let requestBody: LikeBoardCommentsRequest = LikeBoardCommentsRequest(commentId: commentId)
            let response: BaseResponse<LikeBoardCommentsDTO> = try await networkClient.fetch(url: url, body: requestBody)
            return response.result
        }
    }
}
