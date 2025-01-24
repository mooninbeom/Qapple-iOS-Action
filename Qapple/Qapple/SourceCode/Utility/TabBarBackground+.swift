//
//  TabBarBackground.swift
//  Qapple
//
//  Created by 김민준 on 1/23/25.
//

import SwiftUI
import UIKit

struct FixedTabBarBackground: ViewModifier {
    
    let color: UIColor
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                UITabBar.appearance().backgroundColor = color
            }
    }
}

extension View {
    
    /// TabBar 배경 색상을 고정합니다.
    func fixedTabBarBackground(color: UIColor) -> some View {
        modifier(FixedTabBarBackground(color: color))
    }
}
