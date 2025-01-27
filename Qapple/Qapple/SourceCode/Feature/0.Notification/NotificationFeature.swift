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
        
        var threshold: Int?
        var hasNext: Bool = false
    }
    
    enum Action {
        case onAppear
        case onRefresh
        case onPagenationCellAppear(Int)
        case notificationCellTapped(Int)
        case reportedNotificationCellTapped
        
        case fetchNotifications([QappleNotification], QappleAPI.PaginationInfo)
        
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {}
    }
    
    @Dependency(\.notificationRepository) var notificationRepository
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear, .onRefresh:
                state.isLoading = true
                
                state.threshold = nil
                state.hasNext = false
                return .run { send in
                    let result = try await notificationRepository.fetchNotificationList(nil)
                    await send(.fetchNotifications(result.0, result.1))
                }
                
            case let .onPagenationCellAppear(index):
                guard state.hasNext, index == state.notifications.count - 1 else { return .none }
                state.isLoading = true
                
                return .run { [threshold = state.threshold] send in
                    let result = try await notificationRepository.fetchNotificationList(threshold)
                    await send(.fetchNotifications(result.0, result.1))
                }
                
            case let .fetchNotifications(notifications, pagenationInfo):
                state.threshold = Int(pagenationInfo.threshold)
                state.hasNext = pagenationInfo.hasNext
                state.notifications.append(contentsOf: notifications)
                
                state.isLoading = false
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
        .ifLet(\.alert, action: \.alert)
    }
}
