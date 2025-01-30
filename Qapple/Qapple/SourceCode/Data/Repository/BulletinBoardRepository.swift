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
        fetchBulletinBoardList: makeFetchBulletinBoardList(),
        postBoard: makePostBoard(),
        fetchSingleBoard: makeFetchSingleBoard(),
        deleteBoard: makeDeleteBoard(),
        likeBoard: makeLikeBoard(),
        searchBoard: makeSearchBoard()
    )
}

extension DependencyValues {
    var bulletinBoardRepository: BulletinBoardRepository {
        get { self[BulletinBoardRepository.self] }
        set { self[BulletinBoardRepository.self] = newValue }
    }
}
