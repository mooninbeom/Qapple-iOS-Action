//
//  NotificationKey.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

extension QappleRepository {
    
    /// 알림 리스트 조회
    static func makeNotificationList() -> (_ threshold: Int?) async throws -> ([QappleNotification], QappleAPI.PaginationInfo) {
        return { threshold in
            let url = try QappleAPI.Notification.notification(threshold: threshold, pageSize: 10).url()
            let response: BaseResponse<NotificationsDTO> = try await networkClient.get(url: url)
            return response.result.toEntityWithThreshold
        }
    }
}
