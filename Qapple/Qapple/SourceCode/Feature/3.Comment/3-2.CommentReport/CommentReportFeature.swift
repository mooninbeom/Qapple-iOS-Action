//
//  CommentReportFeature.swift
//  Qapple
//
//  Created by 문인범 on 1/21/25.
//

import ComposableArchitecture

@Reducer
struct CommentReportFeature {
    @ObservableState
    struct State: Equatable {
        let commentId: Int
        
        @Presents var alert: AlertState<Action.Alert>?
        
        var isLoading: Bool = false
        var reportType: CommentReportType = .DISTRIBUTION_OF_ILLEGAL_PHOTOGRAPHS
    }
    
    enum Action {
        case alert(PresentationAction<Alert>)
        case reportListItemTapped(Int)
        
        @CasePathable
        enum Alert: Equatable {
            case deleteButtonTapped(Int)
            case completionButtonTapped
        }
    }
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert(.dismiss):
                return .none
                
            case let .reportListItemTapped(index):
                state.alert = AlertState {
                    TextState("답변을 신고하시겠어요?")
                } actions: {
                    ButtonState(role: .cancel){
                        TextState("취소")
                    }
                    ButtonState(role: .destructive, action: .deleteButtonTapped(index)) {
                        TextState("신고")
                    }
                }
                return .none
                
            case let .alert(.presented(.deleteButtonTapped(index))):
                // TODO: 삭제 버튼 눌렀을 떄 action
                state.alert = AlertState {
                    TextState("신고가 완료됐어요")
                } actions: {
                    ButtonState(action: .completionButtonTapped) {
                        TextState("확인")
                    }
                } message: {
                    TextState("신고한 댓글은 블라인드 처리 되며, 관리자 검토 후 최대 24시간 이내에 조치 될 예정이에요")
                }
                return .none
                
            case .alert(.presented(.completionButtonTapped)):
                // TODO: 네비게이션 pop
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
