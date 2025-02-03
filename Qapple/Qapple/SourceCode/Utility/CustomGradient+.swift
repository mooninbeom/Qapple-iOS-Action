//
//  CustomGradient+.swift
//  Qapple
//
//  Created by 김민준 on 1/21/25.
//

import SwiftUI

extension LinearGradient {
    
    /// 배경 그라디언트
    static var backgroundGradient: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.12, green: 0.12, blue: 0.13).opacity(0), location: 0.00),
                Gradient.Stop(color: Color(red: 0.93, green: 0.26, blue: 0.38).opacity(0.56), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0.55),
            endPoint: UnitPoint(x: 0.5, y: 2)
        )
    }
    
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
