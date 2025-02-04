//
//  BulletinBoardEllipsisFeature.swift
//  Qapple
//
//  Created by Simmons on 1/23/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BulletinBoardEllipsisFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var boardId: Int = 0
        var isMine: Bool = false
    }
    
    enum Action {
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)
        case deleteButtonTapped
        case successDeleteButtonTapped
        case reportButtonTapped
        
        enum Alert {
            case confirmDelete
            case successDelete
        }
        
        enum Delegate {
            case confirmDelete
            case successDelete
        }
    }
    
    @Dependency(\.bulletinBoardRepository) var bulletinBoardRepository
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert(.presented(.confirmDelete)):
                state.alert = .confirmDelete
                return .run { send in
                    await send(.delegate(.confirmDelete))
                    await send(.successDeleteButtonTapped)
                }
                
            case .alert(.presented(.successDelete)):
                let boardId = state.boardId
                return .run { send in
                    await send(.delegate(.successDelete))
                    try await bulletinBoardRepository.deleteBoard(boardId)
                }
                
            case .alert:
                return .none
                
            case .delegate:
                return .none
                
            case .deleteButtonTapped:
                state.alert = .confirmDelete
                return .none
                
            case .successDeleteButtonTapped:
                state.alert = .successDelete
                return .none
                
            case .reportButtonTapped:
                // TODO: Navigation 처리
                return .run { _ in
                    await self.dismiss()
                }
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - BulletinBoardEllipsisAlert

extension AlertState where Action == BulletinBoardEllipsisFeature.Action.Alert {
    static let confirmDelete = Self {
        TextState("게시글을 삭제할까요?")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("취소")
        }
        ButtonState(role: .destructive, action: .confirmDelete) {
            TextState("삭제하기")
        }
    } message: {
        TextState("삭제 된 게시글은 복구할 수 없어요")
    }
    
    static let successDelete = Self {
        TextState("삭제가 완료됐어요")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("확인")
        }
    }
}
