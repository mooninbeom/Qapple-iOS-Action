//
//  CommentFeature.swift
//  Qapple
//
//  Created by 문인범 on 1/21/25.
//

import Foundation
import ComposableArchitecture

/**
 게시판 댓글(CommentView) Reducer
 */
@Reducer
struct CommentFeature {
    @ObservableState
    struct State: Equatable {
        var board: BulletinBoard
        
        var text: String = ""
        
        var commentList: [BoardComment] = []
        var paginationInfo = QappleAPI.PaginationInfo(threshold: "", hasNext: false)
        
        // MARK: 추후 자동 스크롤 연결 예정
        var scrollIndex: Int?
        var isLoading: Bool = false
        
        @Presents var sheet: Sheet.State?
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case onAppear
        case onDisappear
        case refresh
        case pagination
        case commentListResponse([BoardComment], QappleAPI.PaginationInfo)
        
        case likeButtonTapped(id: Int)
        case uploadButtonTapped
        case deleteButtonTapped(id: Int)
        case reportButtonTapped(id: Int)
        
        case commentTextChanged(text: String)
        case likeBoardButtonTapped
        case likeBoard
        case seeMoreAction
        case toggleLoading(Bool)
        
        case sheet(PresentationAction<Sheet.Action>)
        case alert(PresentationAction<Alert>)
        case networkErrorAlert
        
        @CasePathable
        enum Alert: Equatable {
            case boardLoadError
            case deleteComment(Int)
        }
    }
    
    @Dependency(\.commentRepository) var commentRepository
    @Dependency(\.bulletinBoardRepository) var bulletinBoardRepository
    
    var body: some ReducerOf<Self> {
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
                        print(error)
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
                
                // MARK: - 버튼 액션 관련(업로드, 좋아요, 삭제, 신고)
            case let .likeButtonTapped(id: id):
                
                let index = state.commentList.firstIndex{ $0.id == id }!
                let isLiked = state.commentList[index].isLiked
                state.commentList[index].isLiked.toggle()
                
                if isLiked {
                    state.commentList[index].heartCount -= 1
                } else {
                    state.commentList[index].heartCount += 1
                }
                
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let _ = try await commentRepository.likeBoardComment(id)
                    } catch {
                        await send(.networkErrorAlert)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .commentTextChanged(text: text):
                state.text = text
                return .none
                
            case .uploadButtonTapped:
                return .run { [
                    text = state.text,
                    boardId = state.board.id
                ] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let _ = try await commentRepository.postBoardComment(boardId, text)
                        await send(.refresh)
                        // TODO: - 댓글 업로드 후 액션 추가
                    } catch {
                        await send(.networkErrorAlert)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .reportButtonTapped(id: _):
                // TODO: CommentReportView로 navigating
                return .none
                
            case let .deleteButtonTapped(id: id):
                state.alert = AlertState {
                    TextState("정말로 댓글을 삭제하시겠습니까?")
                } actions: {
                    ButtonState(role: .destructive, action: .deleteComment(id), label: { TextState("삭제") })
                    ButtonState(role: .cancel, label: { TextState("취소") })
                }
                return .none
                
                // MARK: - Alert 관련 액션
                /// Delete 버튼 alert
            case let .alert(.presented(.deleteComment(id))):
                // TODO: 댓글 삭제 구현
                print("댓글 아이디: \(id) 삭제")
                
                state.alert = AlertState {
                    TextState("댓글이 삭제되었습니다")
                } actions: {
                    ButtonState(label: { TextState("확인")})
                }
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let _ = try await commentRepository.deleteBoardComment(id)
                        await send(.refresh)
                    } catch {
                        await send(.networkErrorAlert)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
                /// 네트워크 오류 대응 alert
            case .networkErrorAlert:
                state.alert = AlertState {
                    TextState("알 수 없는 오류가 발생했습니다.")
                } actions: {
                    ButtonState(role: .cancel, label: { TextState("확인") })
                } message: {
                    TextState("잠시후 다시 시도해주세요.")
                }
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
                        sheetData: .bulletinBoard(state.board)
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
                
            case .sheet, .alert:
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



private let samplePost = BulletinBoard(
    id: 1,
    writerId: 1,
    writerNickname: "이호창",
    content: "특전사",
    heartCount: 10,
    commentCount: 13,
    createAt: .init(),
    isMine: false,
    isReported: false,
    isLiked: true
)
