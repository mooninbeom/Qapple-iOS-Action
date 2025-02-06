//
//  ReportFeature.swift
//  Qapple
//
//  Created by 김민준 on 2/6/25.
//

import ComposableArchitecture

@Reducer
struct ReportFeature {
    
    @ObservableState
    struct State: Equatable {
        var reportData: ReportData
        var isLoading = false
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case backButtonTapped
        case reportCellTapped(ReportType)
        case completionReport
        case toggleLoading(Bool)
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {
            case confirmReport(ReportData, ReportType)
            case confirmCompletion
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { send in await dismiss() }
                
            case let .reportCellTapped(reportType):
                state.alert = .reportCheck(from: state.reportData, type: reportType)
                return .none
                
            case .completionReport:
                state.alert = .reportComplete(from: state.reportData)
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
            
            case .alert:
                return .none
            }
        }
    }
}

// MARK: - Report Type

extension ReportFeature {
    
    /// 어떤 Data를 신고하는지
    enum ReportData: Equatable {
        case answer(Answer)
        case bulletinBoard(BulletinBoard)
    }
    
    /// 신고 유형
    enum ReportType: String, CaseIterable {
        case DISTRIBUTION_OF_ILLEGAL_PHOTOGRAPHS
        case COMMERCIAL_ADVERTISING_AND_SALES
        case INADEQUATE_BOARD_CHARACTER
        case ABUSIVE_LANGUAGE_AND_DISPARAGEMENT
        case POLITICAL_PARTY_OR_POLITICIAN_DEMEANING_AND_CAMPAIGNING
        case LEAK_IMPERSONATION_FRAUD
        case TRICK_TEASING_PLASTERED
        
        var toString: String {
            switch self {
            case .DISTRIBUTION_OF_ILLEGAL_PHOTOGRAPHS: "불법촬영물 등의 유통"
            case .COMMERCIAL_ADVERTISING_AND_SALES: "상업적 광고 및 판매"
            case .INADEQUATE_BOARD_CHARACTER: "게시판 성격에 부적절함"
            case .ABUSIVE_LANGUAGE_AND_DISPARAGEMENT: "욕설/비하"
            case .POLITICAL_PARTY_OR_POLITICIAN_DEMEANING_AND_CAMPAIGNING: "정당/정치인 비하 및 선거운동"
            case .LEAK_IMPERSONATION_FRAUD: "유출/사칭/사기"
            case .TRICK_TEASING_PLASTERED: "낚시/놀림/도배"
            }
        }
    }
}

// MARK: - Alert

extension AlertState where Action == ReportFeature.Action.Alert {
    
    /// 신고 확인
    static func reportCheck(from reportData: ReportFeature.ReportData, type: ReportFeature.ReportType) -> Self {
        let targetText = switch reportData {
        case .answer: "답변"
        case .bulletinBoard: "게시글"
        }
        return Self {
            TextState("\(targetText)을 신고하시겠어요?")
        } actions: {
            ButtonState(role: .cancel) {
                TextState("취소")
            }
            ButtonState(role: .destructive, action: .confirmReport(reportData, type)) {
                TextState("신고하기")
            }
        }
    }
    
    /// 신고 완료
    static func reportComplete(from reportData: ReportFeature.ReportData) -> Self {
        let targetText = switch reportData {
        case .answer: "답변"
        case .bulletinBoard: "게시글"
        }
        return Self {
            TextState("\(targetText)이 신고되었어요")
        } actions: {
            ButtonState(role: .none, action: .confirmCompletion) {
                TextState("확인")
            }
        } message: {
            TextState("신고한 \(targetText)은 블라인드 처리 되며, 관리자 검토 후 최대 24시간 이내에 조치 될 예정이에요")
        }
    }
}

