//
//  HapticService.swift
//  Qapple
//
//  Created by 김민준 on 2/8/25.
//

import UIKit

struct HapticService {
    
    private init() {}
    
    private static let notificationGenerator = UINotificationFeedbackGenerator()
    private static let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        notificationGenerator.notificationOccurred(type)
    }
    
    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        impactGenerator.impactOccurred()
    }
}
