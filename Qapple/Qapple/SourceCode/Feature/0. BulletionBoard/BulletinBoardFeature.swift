//
//  BulletinBoardFeature.swift
//  Qapple
//
//  Created by Simmons on 1/23/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BulletinBoardFeature {
    @ObservableState
    struct State: Equatable {
        var bulletinBoardList: [BulletinBoard] = []
        var isLoading: Bool = false
        var threshold: Int?
        var hasNext: Bool = false
    }
    
    enum Action {
        case getBulletinBoardList
        case refreshBulletinBoardList
        case fetchBulletinBoardList(([BulletinBoard], QappleAPI.PaginationInfo))
        case boardButtonTapped
        case likeBoardButtonTapped
        case seeMoreButtonTapped
        case searchButtonTapped
        case notificationButtonTapped
        case postBoardButtonTapped
    }
    
    @Dependency(\.bulletinBoardRepository) var bulletinBoardRepository
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .getBulletinBoardList:
                state.isLoading = true
                let threshold = state.threshold
                
                return .run { send in
                    let data = try await bulletinBoardRepository.fetchBulletinBoardList(threshold)
                    await send(.fetchBulletinBoardList(data))
                }
                
            case .refreshBulletinBoardList:
                state.isLoading = true
                state.bulletinBoardList = []
                return .run { send in
                    let data = try await bulletinBoardRepository.fetchBulletinBoardList(nil)
                    await send(.fetchBulletinBoardList(data))
                }
                
            case let .fetchBulletinBoardList((bulletinBoardList, paginationInfo)):
                state.isLoading = false
                state.bulletinBoardList.append(contentsOf: bulletinBoardList)
                state.threshold = Int(paginationInfo.threshold)
                state.hasNext = paginationInfo.hasNext
                return .none
                
            case .boardButtonTapped:
                return .none
                
            case .likeBoardButtonTapped:
                return .none
                
            case .seeMoreButtonTapped:
                return .none
                
            case .searchButtonTapped:
                return .none
                
            case .notificationButtonTapped:
                return .none
                
            case .postBoardButtonTapped:
                // TODO: Navigiation 처리
                return .none
            }
        }
    }
}

