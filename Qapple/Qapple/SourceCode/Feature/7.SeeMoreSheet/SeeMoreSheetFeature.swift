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
        var sheetData: SheetData
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case deleteButtonTapped
        case reportButtonTapped
        case completionDeletion
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {
            case confirmDeletion(SheetData)
            case confirmCompletion
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .deleteButtonTapped:
                state.alert = .deletionCheck(from: state.sheetData)
                return .none
                
            case .reportButtonTapped:
                return .none
                
            case .completionDeletion:
                state.alert = .deletionComplete(from: state.sheetData)
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
        case myAnswer(AnswerOfProfile)
        case answer(Answer)
        case bulletinBoard
    }
}

// MARK: - Alert

extension AlertState where Action == SeeMoreSheetFeature.Action.Alert {
    
    /// 삭제 확인
    static func deletionCheck(from sheetData: SeeMoreSheetFeature.SheetData) -> Self {
        let targetText = sheetData == .bulletinBoard ? "게시글" : "답변"
        return Self {
            TextState("\(targetText)을 삭제하시겠어요?")
        } actions: {
            ButtonState(role: .cancel) {
                TextState("취소")
            }
            ButtonState(role: .destructive, action: .confirmDeletion(sheetData)) {
                TextState("삭제하기")
            }
        } message: {
            TextState("삭제한 \(targetText)은 복구할 수 없어요")
        }
    }
    
    /// 삭제 완료
    static func deletionComplete(from sheetData: SeeMoreSheetFeature.SheetData) -> Self {
        let targetText = sheetData == .bulletinBoard ? "게시글" : "답변"
        return Self {
            TextState("\(targetText)이 삭제되었어요")
        } actions: {
            ButtonState(role: .none, action: .confirmCompletion) {
                TextState("확인")
            }
        }
    }
}
