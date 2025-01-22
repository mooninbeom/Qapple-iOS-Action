//
//  BulletinBoardKey.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

extension QappleRepository {
    
    /// 게시글 조회
    static func makeFetchBulletinBoardList() -> (_ threshold: Int?) async throws -> ([BulletinBoard], QappleAPI.PaginationInfo) {
        return { threshold in
            let url = try QappleAPI.Board.list(threshold: threshold, pageSize: 25).url()
            let response: BaseResponse<BulletinBoardDTO> = try await networkClient.get(url: url)
            return response.result.toEntityWithThreshold
        }
    }
    
    /// 게시글 생성
    static func makePostBoard() -> (_ content: String) async throws -> PostBoardDTO {
        return { content in
            let url = try QappleAPI.Board.post.url()
            let requestBody: PostBoardRequest = PostBoardRequest(content: content, boardType: "FREEBOARD")
            let response: BaseResponse<PostBoardDTO> = try await networkClient.post(url: url, body: requestBody)
            return response.result
        }
    }
    
    /// 게시글 단건 조회
    static func makeFetchSingleBoard() -> (_ boardId: Int) async throws -> BulletinBoard {
        return { boardId in
            let url = try QappleAPI.Board.single(boardId: boardId).url()
            let response: BaseResponse<BulletinBoardDTO.Content> = try await networkClient.get(url: url)
            return response.result.toEntity
        }
    }
    
    /// 게시글 삭제
    static func makeDeleteBoard() -> (_ boardId: Int) async throws -> DeleteBoardDTO {
        return { boardId in
            let url = try QappleAPI.Board.delete(boardId: boardId).url()
            let response: BaseResponse<DeleteBoardDTO> = try await networkClient.delete(url: url)
            return response.result
        }
    }
    
    /// 게시글 좋아요/취소
    static func makeLikeBoard() -> (_ boardId: Int) async throws -> LikeBoardDTO {
        return { boardId in
            let url = try QappleAPI.Board.like(boardId: boardId).url()
            let requestBody: LikeBoardRequest = LikeBoardRequest(boardId: boardId)
            let response: BaseResponse<LikeBoardDTO> = try await networkClient.post(url: url, body: requestBody)
            return response.result
        }
    }
    
    /// 게시글 검색
    static func makeSearchBoard() -> (_ keyword: String?, _ threshold: Int?) async throws -> ([BulletinBoard], QappleAPI.PaginationInfo) {
        return { keyword, threshold in
            let url = try QappleAPI.Board.search(keyword: keyword, threshold: threshold, pageSize: 25).url()
            let response: BaseResponse<SearchBoardDTO> = try await networkClient.get(url: url)
            return response.result.toEntityWithThreshold
        }
    }
}
