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
        @Presents var alert: AlertState<Action.Alert>?
        var bulletinBoardList: [BulletinBoard] = []
        var academyEvents: [AcademyEvent] = [.macro, .epilogue]
        var isLoading: Bool = false
        var threshold: Int?
        var hasNext: Bool = false
    }
    
    enum Action {
        case sheet(PresentationAction<Sheet.Action>)
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)
        
        case getBulletinBoardList
        case refreshBulletinBoardList
        case fetchBulletinBoardList(([BulletinBoard], QappleAPI.PaginationInfo))
        
        case boardCellTapped(BulletinBoard)
        case reportButtonTapped
        case likeBoardButtonTapped(Int)
        case ellipsisButtonTapped(Int, Bool)
        case searchButtonTapped
        case notificationButtonTapped
        case postBoardButtonTapped
        case toggleLoading(Bool)
        
        enum Alert {
            case confirmReport
        }
        
        enum Delegate {
            case confirmReport
        }
    }
    
    @Dependency(\.bulletinBoardRepository) var bulletinBoardRepository
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .sheet(.presented(.ellipsisButtonTap(.delegate(.confirmDelete)))):
                return .none
                
            case .sheet:
                return .none
                
            case .alert(.presented(.confirmReport)):
                return .run { send in
                    await send(.delegate(.confirmReport))
                }
                
            case .alert:
                return .none
                
            case .delegate:
                return .none
                
            case .getBulletinBoardList:
                let threshold = state.threshold
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let data = try await bulletinBoardRepository.fetchBulletinBoardList(threshold)
                        await send(.fetchBulletinBoardList(data))
                    } catch {
                        print(error)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .refreshBulletinBoardList:
                state.bulletinBoardList = []
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let data = try await bulletinBoardRepository.fetchBulletinBoardList(nil)
                        await send(.fetchBulletinBoardList(data))
                    } catch {
                        print(error)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .fetchBulletinBoardList((bulletinBoardList, paginationInfo)):
                state.bulletinBoardList.append(contentsOf: bulletinBoardList)
                state.threshold = Int(paginationInfo.threshold)
                state.hasNext = paginationInfo.hasNext
                return .none
                
            case let .boardCellTapped(board):
                print("게시판 정보\(board)")
                // TODO: Navigation 처리
                return .none
                
            case .reportButtonTapped:
                state.alert = .confirmReport
                return .none
                
            case let .likeBoardButtonTapped(boardId):
                if let index = state.bulletinBoardList.firstIndex(where: {$0.id == boardId}) {
                    state.bulletinBoardList[index].isLiked.toggle()
                    state.bulletinBoardList[index].heartCount += state.bulletinBoardList[index].isLiked ? 1 : -1
                }
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await bulletinBoardRepository.likeBoard(boardId)
                    } catch {
                        print(error)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
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
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
            }
        }
        .ifLet(\.$sheet, action: \.sheet)
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - BulletinBoardSheet

extension BulletinBoardFeature {
    @Reducer
    enum Sheet {
        case ellipsisButtonTap(BulletinBoardEllipsisFeature)
    }
}

extension BulletinBoardFeature.Sheet.State: Equatable {}

// MARK: - BulletinBoardAlert

extension AlertState where Action == BulletinBoardFeature.Action.Alert {
    static let confirmReport = Self {
        TextState("신고된 게시글")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("확인")
        }
    } message: {
        TextState("신고된 게시글은 열람할 수 없습니다.")
    }
}
