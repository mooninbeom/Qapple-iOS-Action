//
//  BulletinBoardRepository.swift
//  Qapple
//
//  Created by Simmons on 1/23/25.
//

import Foundation
import ComposableArchitecture

struct BulletinBoardRepository {
    
    var fetchBulletinBoardList: (_ threshold: Int?) async throws -> ([BulletinBoard], QappleAPI.PaginationInfo)
    var postBoard: (_ content: String) async throws -> Void
    var fetchSingleBoard: (_ boardId: Int) async throws -> BulletinBoard
    var deleteBoard: (_ boardId: Int) async throws -> Void
    var likeBoard: (_ boardId: Int) async throws -> Void
    var searchBoard: (_ keyword: String?, _ threshold: Int?) async throws -> ([BulletinBoard], QappleAPI.PaginationInfo)
}

extension BulletinBoardRepository: DependencyKey {
    
    static let liveValue = Self(
        fetchBulletinBoardList: { threshold in
            let url = try QappleAPI.Board.list(threshold: threshold, pageSize: 25).url()
            let response: BaseResponse<BulletinBoardDTO> = try await NetworkService.shared.get(url: url)
            return response.result.toEntityWithThreshold
        },
        postBoard: { content in
            let url = try QappleAPI.Board.post.url()
            let requestBody: PostBoardRequest = PostBoardRequest(content: content, boardType: "FREEBOARD")
            let response: BaseResponse<PostBoardDTO> = try await NetworkService.shared.post(url: url, body: requestBody)
        },
        fetchSingleBoard: { boardId in
            let url = try QappleAPI.Board.single(boardId: boardId).url()
            let response: BaseResponse<BulletinBoardDTO.Content> = try await NetworkService.shared.get(url: url)
            return response.result.toEntity
        },
        deleteBoard: { boardId in
            let url = try QappleAPI.Board.delete(boardId: boardId).url()
            let response: BaseResponse<DeleteBoardDTO> = try await NetworkService.shared.delete(url: url)
        },
        likeBoard: { boardId in
            let url = try QappleAPI.Board.like(boardId: boardId).url()
            let requestBody: LikeBoardRequest = LikeBoardRequest(boardId: boardId)
            let response: BaseResponse<LikeBoardDTO> = try await NetworkService.shared.post(url: url, body: requestBody)
        },
        searchBoard: { keyword, threshold in
            let url = try QappleAPI.Board.search(keyword: keyword, threshold: threshold, pageSize: 25).url()
            let response: BaseResponse<SearchBoardDTO> = try await NetworkService.shared.get(url: url)
            return response.result.toEntityWithThreshold
        }
    )
    
    static let previewValue = Self(
        fetchBulletinBoardList: { threshold in
            (stubBulletinBoardList, QappleAPI.PaginationInfo(threshold: "0", hasNext: false))
        },
        postBoard: { content in
            print("게시글이 성공적으로 등록되었습니다: \(content)")
        },
        fetchSingleBoard: { boardId in
            stubBulletinBoardList.first { $0.id == boardId } ?? stubBulletinBoardList[0]
        },
        deleteBoard: { boardId in
            print("게시글이 성공적으로 삭제되었습니다: \(boardId)")
        },
        likeBoard: { boardId in
            print("게시글에 좋아요를 눌렀습니다: \(boardId)")
        },
        searchBoard: { keyword, threshold in
            let filteredList = stubBulletinBoardList.filter { $0.content.contains(keyword ?? "") }
            return (filteredList, QappleAPI.PaginationInfo(threshold: "0", hasNext: false))
        }
    )
}

extension DependencyValues {
    var bulletinBoardRepository: BulletinBoardRepository {
        get { self[BulletinBoardRepository.self] }
        set { self[BulletinBoardRepository.self] = newValue }
    }
}

extension BulletinBoardRepository {
    
    private static var stubBulletinBoardList: [BulletinBoard] {
        var boardList: [BulletinBoard] = []
        for i in 0..<10 {
            boardList.append(
                BulletinBoard(
                    id: i,
                    writerId: i,
                    writerNickname: "사용자 \(i)",
                    content: "테스트 게시글 내용 \(i)",
                    heartCount: i * 2,
                    commentCount: i,
                    createAt: .init(timeIntervalSinceNow: TimeInterval(i * -5000)),
                    isMine: i % 2 == 0,
                    isReported: false,
                    isLiked: i % 3 == 0
                )
            )
        }
        return boardList
    }
}
