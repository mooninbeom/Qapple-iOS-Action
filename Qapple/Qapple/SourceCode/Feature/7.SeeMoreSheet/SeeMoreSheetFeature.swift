//
//  SeeMoreSheetFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/27/25.
//

import ComposableArchitecture

@Reducer
struct SeeMoreSheetFeature {
    
    @ObservableState
    struct State: Equatable {
        var sheetTarget: SheetTarget
        var dataType: DataType
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case deleteButtonTapped
        case reportButtonTapped(DataType)
        case completionDeletion
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {
            case confirmDeletion(DataType)
            case confirmCompletion
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .deleteButtonTapped:
                state.alert = .deletionCheck(from: state.dataType)
                return .none
                
            case .reportButtonTapped:
                return .none
                
            case .completionDeletion:
                state.alert = .deletionComplete(from: state.dataType)
                return .none
                
            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - SheetType

extension SeeMoreSheetFeature {
    
    /// 어떤 사용자의 Sheet인지
    enum SheetTarget {
        case mine
        case others
    }
    
    /// Sheet가 어떤 Data를 이용하는지
    enum SheetData: Equatable {
        case answer(Answer)
        case bulletinBoard(BulletinBoard)
    }
}

// MARK: - Alert

extension AlertState where Action == SeeMoreSheetFeature.Action.Alert {
    
    /// 삭제 확인
    static func deletionCheck(from dataType: DataType) -> Self {
        let targetText = switch dataType {
        case .answer: "답변"
        case .bulletinBoard: "게시글"
        case .comment: "댓글"
        }
        return Self {
            TextState("\(targetText)을 삭제하시겠어요?")
        } actions: {
            ButtonState(role: .cancel) {
                TextState("취소")
            }
            ButtonState(role: .destructive, action: .confirmDeletion(dataType)) {
                TextState("삭제하기")
            }
        } message: {
            TextState("삭제한 \(targetText)은 복구할 수 없어요")
        }
    }
    
    /// 삭제 완료
    static func deletionComplete(from dataType: DataType) -> Self {
        let targetText = switch dataType {
        case .answer: "답변"
        case .bulletinBoard: "게시글"
        case .comment: "댓글"
        }
        return Self {
            TextState("\(targetText)이 삭제되었어요")
        } actions: {
            ButtonState(role: .none, action: .confirmCompletion) {
                TextState("확인")
            }
        }
    }
}
