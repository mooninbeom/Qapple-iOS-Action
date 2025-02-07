//
//  HapticService.swift
//  Qapple
//
//  Created by 김민준 on 1/20/25.
//

import UIKit

final class HapticService {
    static let shared = HapticService()
    private init() {}
    
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        notificationGenerator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        impactGenerator.impactOccurred()
    }
}
