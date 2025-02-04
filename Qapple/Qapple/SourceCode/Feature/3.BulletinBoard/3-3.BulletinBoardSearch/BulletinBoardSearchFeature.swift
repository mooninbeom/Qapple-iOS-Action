//
//  BulletinBoardSearchFeature.swift
//  Qapple
//
//  Created by Simmons on 1/29/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BulletinBoardSearchFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var sheet: Sheet.State?
        var searchBoardList: [BulletinBoard] = []
        var paginationInfo = QappleAPI.PaginationInfo(threshold: "", hasNext: false)
        var searchText: String = ""
        var isLoading = false
    }
    
    enum Action: BindableAction {
        case onAppear // 검색 문구 변화 시 호출
        case onDisappear
        case refresh
        case pagination
        case searchBoardListResponse([BulletinBoard], QappleAPI.PaginationInfo)
        
        case backButtonTapped
        case likeBoardButtonTapped(BulletinBoard)
        case likeBoard(Int)
        case deleteBoard(Int)
        case searchTextChanged
        case binding(BindingAction<State>)
        case postBoardButtonTapped
        case seeMoreAction(BulletinBoard)
        case toggleLoading(Bool)
        
        case sheet(PresentationAction<Sheet.Action>)
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.continuousClock) var clock
    @Dependency(\.bulletinBoardRepository) var bulletinBoardRepository
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear,
                    .refresh:
                state.searchBoardList = []
                return .run { [searchText = state.searchText] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let response = try await bulletinBoardRepository.searchBoard(searchText, nil)
                        await send(.searchBoardListResponse(response.0, response.1))
                    } catch {
                        print(error)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .onDisappear:
                return .none
                
            case .pagination:
                return .run { [
                    threshold = Int(state.paginationInfo.threshold),
                    searchText = state.searchText
                ] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let response = try await bulletinBoardRepository.searchBoard(searchText, threshold)
                        await send(.searchBoardListResponse(response.0, response.1))
                    } catch {
                        print(error)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .searchBoardListResponse(searchBoardList, paginationInfo):
                state.searchBoardList += searchBoardList
                state.paginationInfo = paginationInfo
                return .none
                
            case .backButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }
                
            case let .likeBoardButtonTapped(board):
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await bulletinBoardRepository.likeBoard(board.id)
                        await send(.likeBoard(board.id))
                    } catch {
                        print(error)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .likeBoard(boardId):
                if let index = state.searchBoardList.firstIndex(where: {$0.id == boardId}) {
                    state.searchBoardList[index].isLiked.toggle()
                    state.searchBoardList[index].heartCount += state.searchBoardList[index].isLiked ? 1 : -1
                }
                return .none
                
            case let .deleteBoard(boardId):
                if let index = state.searchBoardList.firstIndex(where: {$0.id == boardId}) {
                    state.searchBoardList.remove(at: index)
                }
                return .none
                
            case .binding(\.searchText):
                return .none
                
            case .searchTextChanged:
                return .concatenate(
                    .cancel(id: "searchDebounce"),
                    .run { [searchText = state.searchText] send in
                        try await self.clock.sleep(for: .seconds(1))
                        if !searchText.isEmpty {
                            await send(.onAppear)
                        }
                    }
                        .cancellable(id: "searchDebounce", cancelInFlight: true)
                )
                
            case .postBoardButtonTapped:
                // TODO: Navigiation 처리
                return .none
                
            case let .seeMoreAction(board):
                state.sheet = .seeMore(
                    .init(
                        sheetTarget: board.isMine ? .mine : .others,
                        sheetData: .bulletinBoard(board)
                    )
                )
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case let .sheet(.presented(.seeMore(.alert(.presented(.confirmDeletion(sheetData)))))):
                guard case let .bulletinBoard(board) = sheetData else { return .none }
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await bulletinBoardRepository.deleteBoard(board.id)
                        await send(.deleteBoard(board.id))
                        await send(.sheet(.presented(.seeMore(.completionDeletion))))
                    } catch {
                        print(error)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .sheet(.presented(.seeMore(.alert(.presented(.confirmCompletion))))):
                state.sheet = nil
                return .run { send in
                    await send(.onDisappear)
                }
                
            case .sheet, .binding:
                return .none
            }
        }
        .ifLet(\.$sheet, action: \.sheet)
    }
}

// MARK: - BulletinBoardSearchSheet

extension BulletinBoardSearchFeature {
    @Reducer(state: .equatable)
    enum Sheet {
        case seeMore(SeeMoreSheetFeature)
    }
}
