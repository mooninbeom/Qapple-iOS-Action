//
//  CommentRepository.swift
//  Qapple
//
//  Created by 문인범 on 1/23/25.
//

import Foundation
import QappleRepository
import ComposableArchitecture


/**
 Comment API 의존성
 */
struct CommentRepository {
    var fetchBoardCommentList: (_ boardId: Int, _ threshold: Int?) async throws -> ([BoardComment], QappleAPI.PaginationInfo)
    var deleteBoardComment: (_ boardCommentId: Int) async throws -> Void
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

// MARK: - DependencyKey

extension CommentRepository: DependencyKey {
    
    @Dependency(\.keychainService) static var keychainService
    
    private static let repositoryService = RepositoryService.shared
    
    private static func accessToken() throws -> String {
        try keychainService.fetchData(.accessToken)
    }
    
    static let liveValue: CommentRepository = Self(
        fetchBoardCommentList: { boardId, threshold in
            let response = try await BoardCommentAPI.fetchList(
                boardId: boardId,
                threshold: threshold,
                pageSize: 25,
                server: repositoryService.server,
                accessToken: accessToken()
            )
            let list = response.content.map {
                BoardComment(
                    id: $0.boardCommentId,
                    writeId: $0.writerId,
                    content: $0.content,
                    heartCount: $0.heartCount,
                    isLiked: $0.isLiked,
                    isMine: $0.isMine,
                    isReport: $0.isReport,
                    createdAt: $0.createdAt.ISO8601ToDate,
                    anonymityId: -2
                )
            }
            let paginationInfo = QappleAPI.PaginationInfo(
                threshold: response.threshold,
                hasNext: response.hasNext
            )
            return (list, paginationInfo)
        },
        deleteBoardComment: { boardCommentId in
            let response = try await BoardCommentAPI.delete(
                commentId: boardCommentId,
                server: repositoryService.server,
                accessToken: accessToken()
            )
        },
        postBoardComment: { boardId, content in
            let response = try await BoardCommentAPI.create(
                boardId: boardId,
                content: content,
                server: repositoryService.server,
                accessToken: accessToken()
            )
        },
        likeBoardComment: { boardCommentId in
            let response = try await BoardCommentAPI.like(
                commentId: boardCommentId,
                server: repositoryService.server,
                accessToken: accessToken()
            )
        }
    )
    
    static let previewValue: CommentRepository = Self(
        fetchBoardCommentList: { _, _ in
            (testComments, .init(threshold: "", hasNext: false))
        },
        deleteBoardComment: { boardCommentId in
                print("\(boardCommentId) 댓글을 삭제했습니다.")
        },
        postBoardComment: { boardId, content in
                print("\(boardId) 게시글에 \(content)글을 작성했습니다.")
        },
        likeBoardComment: { commentId in
            print("게시글에 좋아요를 눌렀습니다: \(commentId)")
        }
    )
}

// MARK: - DependencyValues

extension DependencyValues {
    var commentRepository: CommentRepository {
        get { self[CommentRepository.self] }
        set { self[CommentRepository.self] = newValue }
    }
}
