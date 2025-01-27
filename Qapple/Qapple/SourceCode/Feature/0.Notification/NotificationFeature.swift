//
//  NotificationFeature.swift
//  Qapple
//
//  Created by 문인범 on 1/26/25.
//

import Foundation
import ComposableArchitecture


@Reducer
struct NotificationFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?

        var notifications = [QappleNotification]()
        
        var isLoading: Bool = false
    }
    
    enum Action {
        case onAppear
        case onRefresh
        case notificationCellTapped(Int)
        case reportedNotificationCellTapped
        
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {}
    }
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear, .onRefresh:
                return .none
                
            case let .notificationCellTapped(index):
                return .send(.reportedNotificationCellTapped)
                
            case .reportedNotificationCellTapped:
                state.alert = AlertState {
                    TextState("신고된 게시글")
                } actions: {
                    ButtonState(role: .none, label: { TextState("확인") })
                } message: {
                    TextState("신고된 게시글은 열람할 수 없습니다.")
                }
                return .none
                
            case .alert:
                return .none
            }
        }
    }
}
