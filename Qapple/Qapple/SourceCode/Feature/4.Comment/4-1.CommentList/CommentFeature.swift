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
        var board: BulletinBoard = samplePost
        
        var text: String = ""
        
        var comments: [BoardComment] = []
        
        // MARK: 추후 자동 스크롤 연결 예정
        var scrollIndex: Int?
        var isLoading: Bool = false
        
        var threshold: Int?
        var hasNext: Bool = false
        
        // 익명화 관련 프로퍼티
        var anonymousArray: [Int:Int] = [:]
        var anonymousIndex: Int = 0
        
        @Presents var sheet: Sheet.State?
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case onDisappear
        case commentViewAppeared
        case paginationCellAppeared
        case fetchCommentData([BoardComment])
        case anonymizeComments([BoardComment], String, Bool)
        
        case likeButtonTapped(id: Int)
        case uploadButtonTapped
        case deleteButtonTapped(id: Int)
        case reportButtonTapped(id: Int)
        
        case refreshCommentList
        
        case commentTextChanged(text: String)
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
            case .onDisappear:
                return .none
            // MARK: - 데이터 fetch 관련 액션
            case .commentViewAppeared, .refreshCommentList:
                
                state.comments.removeAll()
                state.threshold = nil
                state.hasNext = false
                return .run { [boardId = state.board.id] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let result = try await commentRepository.fetchBoardCommentList(boardId, nil)
                        await send(.anonymizeComments(result.0, result.1.threshold, result.1.hasNext))
                    } catch {
                        await send(.networkErrorAlert)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .paginationCellAppeared:
                guard state.hasNext else { return .none }
                return .run { [
                    boardId = state.board.id,
                    threshold = state.threshold
                ] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let result = try await commentRepository.fetchBoardCommentList(boardId, threshold)
                        await send(.anonymizeComments(result.0, result.1.threshold, result.1.hasNext))
                    } catch {
                        await send(.networkErrorAlert)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .fetchCommentData(comments):
                state.comments.append(contentsOf: comments)
                return .none
                
            // MARK: - 버튼 액션 관련(업로드, 좋아요, 삭제, 신고)
            case let .likeButtonTapped(id: id):
                
                let index = state.comments.firstIndex{ $0.id == id }!
                let isLiked = state.comments[index].isLiked
                state.comments[index].isLiked.toggle()
                
                if isLiked {
                    state.comments[index].heartCount -= 1
                } else {
                    state.comments[index].heartCount += 1
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
                        await send(.refreshCommentList)
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
                        await send(.refreshCommentList)
                    } catch {
                        await send(.networkErrorAlert)
                    }
                    await send(.toggleLoading(true), animation: .bouncy)
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
                
            case .alert:
                return .none
                
            // MARK: 여러가지 메소드들
            /// BoardComment 익명화 메소드
            case let .anonymizeComments(comments, threshold, hasNext):
                state.threshold = Int(threshold)
                state.hasNext = hasNext
                
                let writerId = state.board.writerId
                let result = comments.map { comment in
                    // 한번이라도 나온 writer인지 여부 판단
                    let isContainName = state.anonymousArray.values.contains {
                        $0 == comment.writeId
                    }
                    
                    if !isContainName { // 처음 나오는 writer일 경우
                        state.anonymousIndex += 1
                        
                        if comment.writeId == writerId {
                            state.anonymousArray.updateValue(comment.writeId, forKey: -1)
                        } else {
                            state.anonymousArray.updateValue(comment.writeId, forKey: state.anonymousIndex)
                        }
                        
                        return BoardComment(
                            id: comment.id,
                            writeId: comment.writeId,
                            content: comment.content,
                            heartCount: comment.heartCount,
                            isLiked: comment.isLiked,
                            isMine: comment.isMine,
                            isReport: comment.isReport,
                            createdAt: comment.createdAt,
                            anonymityId: (comment.writeId == writerId) ? -1 : state.anonymousIndex
                        )
                    } else { // 한번 이상 나온 writer일 경우
                        // 해당 value의 key 값을 찾아 name의 index로 제공
                        let currentIndex = state.anonymousArray
                            .filter { $0.value == comment.writeId }
                            .first!.key
                        
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
                
                return .send(.fetchCommentData(result))
                
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
//                        await send(.deleteBoard(board.id))
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
                
            case .sheet:
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
    private func anonymizeComment(id: Int, comments: [CommentEntity]) -> [CommentEntity] {
        var anonymousArray: [Int: Int] = [:]
        var anonymousIndex: Int = 0
        
        let result = comments.map { comment in
            
            // 한번이라도 나온 writer인지 여부 판단
            let isContainName = anonymousArray.values.contains {
                $0 == comment.writerId
            }
            
            if !isContainName { // 처음 나오는 writer일 경우
                anonymousIndex += 1
                
                if comment.writerId == id {
                    anonymousArray.updateValue(comment.writerId, forKey: -1)
                } else {
                    anonymousArray.updateValue(comment.writerId, forKey: anonymousIndex)
                }
                
                return CommentEntity(
                    id: comment.id,
                    writerId: (comment.writerId == id) ? -1 : anonymousIndex,
                    content: comment.content,
                    createdAt: comment.createdAt,
                    heartCount: comment.heartCount,
                    isLiked: comment.isLiked,
                    isMine: comment.isMine,
                    isReport: comment.isReport
                )
            } else { // 한번 이상 나온 writer일 경우
                // 해당 value의 key 값을 찾아 name의 index로 제공
                let currentIndex = anonymousArray
                    .filter { $0.value == comment.writerId }
                    .first!.key
                
                return CommentEntity(
                    id: comment.id,
                    writerId: currentIndex,
                    content: comment.content,
                    createdAt: comment.createdAt,
                    heartCount: comment.heartCount,
                    isLiked: comment.isLiked,
                    isMine: comment.isMine,
                    isReport: comment.isReport
                )
            }
        }
        
        return result
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
