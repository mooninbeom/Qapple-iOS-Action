//
//  NotificationKey.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

extension QappleRepository {
    
    /// 알림 리스트 조회
    static func makeFetchNotificationList() -> (_ threshold: Int?) async throws -> ([QappleNotification], QappleAPI.PaginationInfo) {
        return { threshold in
            let url = try QappleAPI.Notification.list(threshold: threshold, pageSize: 25).url()
            let response: BaseResponse<NotificationsDTO> = try await networkClient.get(url: url)
            return response.result.toEntityWithThreshold
        }
    }
}
