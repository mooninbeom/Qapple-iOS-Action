//
//  HapticService.swift
//  Qapple
//
//  Created by 김민준 on 2/7/25.
//

import ComposableArchitecture
import UIKit

struct HapticService {
    var notification: (_ type: UINotificationFeedbackGenerator.FeedbackType) -> Void
    var impact: (_ style: UIImpactFeedbackGenerator.FeedbackStyle) -> Void
}

// MARK: - DependencyKey

extension HapticService: DependencyKey {
    
    static let liveValue = Self(
        notification: { UINotificationFeedbackGenerator().notificationOccurred($0) },
        impact: { UIImpactFeedbackGenerator(style: $0).impactOccurred() }
    )
}

// MARK: - DependencyValues

extension DependencyValues {
    var hapticService: HapticService {
        get { self[HapticService.self] }
        set { self[HapticService.self] = newValue }
    }
}
