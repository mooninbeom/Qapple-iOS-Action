//
//  CommentFeature.swift
//  Qapple
//
//  Created by 문인범 on 1/21/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CommentFeature {
    @ObservableState
    struct State: Equatable {
        var board: BulletinBoard
        var commentText: String = ""
        var commentList: [BoardComment] = []
        var paginationInfo = QappleAPI.PaginationInfo(threshold: "", hasNext: false)
        // MARK: 추후 자동 스크롤 연결 예정
        var scrollIndex: Int?
        var isLoading: Bool = false
        @Presents var sheet: Sheet.State?
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action: BindableAction {
        case onAppear
        case onDisappear
        case refresh
        case pagination
        case commentListResponse([BoardComment], QappleAPI.PaginationInfo)
        
        case backButtonTapped
        case likeCommentButtonTapped(BoardComment)
        case likeComment(Int)
        case uploadCommentButtonTapped
        case commentTextReset
        case reportButtonTapped
        case deleteCommentButtonTapped(BoardComment)
        case successDeletion
        
        case likeBoardButtonTapped
        case likeBoard
        case seeMoreAction
        case toggleLoading(Bool)
        case binding(BindingAction<State>)
        
        case networkErrorAlert
        case sheet(PresentationAction<Sheet.Action>)
        case alert(PresentationAction<Alert>)
        
        
        enum Alert: Equatable {
            case networkError
            case confirmDeletion(Int)
            case successDeletion
        }
    }
    
    @Dependency(\.commentRepository) var commentRepository
    @Dependency(\.bulletinBoardRepository) var bulletinBoardRepository
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear, .refresh:
                state.commentList = []
                return .run { [boardId = state.board.id] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let response = try await commentRepository.fetchBoardCommentList(boardId, nil)
                        await send(.commentListResponse(response.0, response.1))
                    } catch {
                        await send(.networkErrorAlert)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .onDisappear:
                return .none
                
            case .pagination:
                return .run { [
                    boardId = state.board.id,
                    threshold = Int(state.paginationInfo.threshold)
                ] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let response = try await commentRepository.fetchBoardCommentList(boardId, threshold)
                        await send(.commentListResponse(response.0, response.1))
                    } catch {
                        await send(.networkErrorAlert)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .commentListResponse(commentList, paginationInfo):
                state.commentList += anonymizeCommentList(state.board.writerId, commentList)
                state.paginationInfo = paginationInfo
                return .none
                
            case .backButtonTapped:
                return .run { _ in
                    await dismiss()
                }
                
            case let .likeCommentButtonTapped(boardComment):
                print(boardComment.id)
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await commentRepository.likeBoardComment(boardComment.id)
                        await send(.likeComment(boardComment.id))
                    } catch {
                        print(error)
                        await send(.networkErrorAlert)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .likeComment(boardCommentId):
                if let index = state.commentList.firstIndex(where: { $0.id == boardCommentId }) {
                    state.commentList[index].isLiked.toggle()
                    state.commentList[index].heartCount += state.commentList[index].isLiked ? 1 : -1
                }
                return .none
                
            case .uploadCommentButtonTapped:
                return .run { [
                    text = state.commentText,
                    boardId = state.board.id
                ] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await commentRepository.postBoardComment(boardId, text)
                        await send(.refresh)
                        await send(.commentTextReset)
                    } catch {
                        await send(.networkErrorAlert)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .commentTextReset:
                state.commentText = ""
                return .none
                
            case .reportButtonTapped:
                // TODO: CommentReportView로 navigating
                return .none
                
            case let .deleteCommentButtonTapped(boardComment):
                state.alert = .confirmDeletion(boardComment.id)
                return .none
                
            case .successDeletion:
                state.alert = .successDeletion
                return .none
                
            case .likeBoardButtonTapped:
                return .run { [board = state.board] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await bulletinBoardRepository.likeBoard(board.id)
                        await send(.likeBoard)
                    } catch {
                        print(error)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .likeBoard:
                if state.board.isLiked {
                    state.board.heartCount -= 1
                } else {
                    state.board.heartCount += 1
                }
                state.board.isLiked.toggle()
                return .none
                
            case .seeMoreAction:
                state.sheet = .seeMore(
                    .init(
                        sheetTarget: state.board.isMine ? .mine : .others,
                        dataType: .bulletinBoard(state.board)
                    )
                )
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case .binding(\.commentText):
                return .none
                
            case .networkErrorAlert:
                state.alert = .networkError
                return .none
                
            case let .sheet(.presented(.seeMore(.alert(.presented(.confirmDeletion(sheetData)))))):
                guard case let .bulletinBoard(board) = sheetData else { return .none }
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await bulletinBoardRepository.deleteBoard(board.id)
                        await send(.sheet(.presented(.seeMore(.completionDeletion))))
                        // TODO: Navigaition 뒤로가기
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
                
            case let .alert(.presented(.confirmDeletion(boardCommentId))):
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await commentRepository.deleteBoardComment(boardCommentId)
                        await send(.refresh)
                        await send(.successDeletion)
                        // TODO: 삭제 후 슬라이드 이동
                    } catch {
                        await send(.networkErrorAlert)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .binding, .sheet, .alert:
                return .none
            }
        }
        .ifLet(\.$sheet, action: \.sheet)
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - BulletinBoardSheet

extension CommentFeature {
    @Reducer(state: .equatable)
    enum Sheet {
        case seeMore(SeeMoreSheetFeature)
    }
}

// MARK: - CommentAlert

extension AlertState where Action == CommentFeature.Action.Alert {
    static func confirmDeletion(_ boardCommentId: Int) -> Self {
        return Self {
            TextState("정말로 댓글을 삭제하시겠습니까?")
        } actions: {
            ButtonState(role: .cancel){
                TextState("취소")
            }
            ButtonState(role: .destructive, action: .confirmDeletion(boardCommentId)) {
                TextState("삭제")
            }
        }
    }
    
    static let successDeletion = Self {
        TextState("댓글이 삭제되었습니다")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("확인")
        }
    }
    
    static let networkError = Self {
        TextState("알 수 없는 오류가 발생했습니다.")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("확인")
        }
    } message: {
        TextState("잠시후 다시 시도해주세요.")
    }
}

extension CommentFeature {
    // 이름을 익명화 해주는 method
    private func anonymizeCommentList(_ BoardWriterId: Int, _ commentList: [BoardComment]) -> [BoardComment] {
        var anonymousArray: [Int: Int] = [:]
        var anonymousIndex: Int = 0
        
        return commentList.map { comment in
            let isContainName = anonymousArray.values.contains { $0 == comment.writeId }
            
            if !isContainName {
                anonymousIndex += 1
                
                let anonymityId = (comment.writeId == BoardWriterId) ? -1 : anonymousIndex
                
                anonymousArray.updateValue(comment.writeId, forKey: anonymityId)
                
                return BoardComment(
                    id: comment.id,
                    writeId: comment.writeId,
                    content: comment.content,
                    heartCount: comment.heartCount,
                    isLiked: comment.isLiked,
                    isMine: comment.isMine,
                    isReport: comment.isReport,
                    createdAt: comment.createdAt,
                    anonymityId: (comment.writeId == BoardWriterId) ? -1 : anonymousIndex
                )
            } else {
                let currentIndex = anonymousArray.first(where: { $0.value == comment.writeId })?.key ?? 0
                
                return BoardComment(
                    id: comment.id,
                    writeId: currentIndex,
                    content: comment.content,
                    heartCount: comment.heartCount,
                    isLiked: comment.isLiked,
                    isMine: comment.isMine,
                    isReport: comment.isReport,
                    createdAt: comment.createdAt,
                    anonymityId: currentIndex
                )
            }
        }
    }
}
