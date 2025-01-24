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
        @Presents var sheet: Sheet.State?
        var bulletinBoardList: [BulletinBoard] = []
        var academyEvents: [AcademyEvent] = [.macro, .epilogue]
        var isLoading: Bool = false
        var threshold: Int?
        var hasNext: Bool = false
    }
    
    enum Action {
        case sheet(PresentationAction<Sheet.Action>)
        
        case getBulletinBoardList
        case refreshBulletinBoardList
        case fetchBulletinBoardList(([BulletinBoard], QappleAPI.PaginationInfo))
        
        case boardButtonTapped
        case likeBoardButtonTapped
        case ellipsisButtonTapped(Int, Bool)
        case searchButtonTapped
        case notificationButtonTapped
        case postBoardButtonTapped
    }
    
    @Dependency(\.bulletinBoardRepository) var bulletinBoardRepository
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .sheet(.presented(.ellipsisButtonTap(.delegate(.confirmDelete)))):
                return .none
                
            case .sheet:
                return .none
                
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
                // TODO: Navigation 처리
                return .none
                
            case .likeBoardButtonTapped:
                return .none
                
            case let .ellipsisButtonTapped(boardId, isMine):
                state.sheet = .ellipsisButtonTap(
                    BulletinBoardEllipsisFeature.State(
                        boardId: boardId, isMine: isMine
                    )
                )
                return .none
                
            case .searchButtonTapped:
                // TODO: Navigation 처리
                return .none
                
            case .notificationButtonTapped:
                // TODO: Navigation 처리
                return .none
                
            case .postBoardButtonTapped:
                // TODO: Navigiation 처리
                return .none
            }
        }
        .ifLet(\.$sheet, action: \.sheet)
    }
}

extension BulletinBoardFeature {
    @Reducer
    enum Sheet {
        case ellipsisButtonTap(BulletinBoardEllipsisFeature)
    }
}

extension BulletinBoardFeature.Sheet.State: Equatable {}
