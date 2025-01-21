//
//  CustomGradient+.swift
//  Qapple
//
//  Created by 김민준 on 1/21/25.
//

import SwiftUI

extension LinearGradient {
    
    /// 타이머 그라디언트
    static var timerGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 212/255, green: 105/255, blue: 249/255),
                Color(red: 244/255, green: 78/255, blue: 156/255),
                Color(red: 232/255, green: 44/255, blue: 201/255).opacity(0.84)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
