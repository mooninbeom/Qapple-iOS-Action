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
        let reportList = [
            "불법촬영물 등의 유통",
            "상업적 광고 및 판매",
            "게시판 성격에 부적절함",
            "욕설/비하",
            "정당/정치인 비하 및 선거운동",
            "유출/사칭/사기",
            "낚시/놀림/도배"
        ]
        
        let commentId: Int
        
        var isReportAlertPresented: Bool = false
        var isReportCompleteAlertPresented: Bool = false
        
        var isLoading: Bool = false
        var reportType: CommentReportType = .DISTRIBUTION_OF_ILLEGAL_PHOTOGRAPHS
    }
    
    enum Action {
        case reportButtonTapped(Int)
    }
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .reportButtonTapped(id):
                return .none
            }
        }
    }
}
