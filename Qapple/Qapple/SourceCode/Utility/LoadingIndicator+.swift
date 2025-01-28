//
//  LoadingIndicator+.swift
//  Qapple
//
//  Created by 김민준 on 1/28/25.
//

import SwiftUI

struct LoadingIndicatorModifier: ViewModifier {
    
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        if isLoading {
            content.overlay {
                LoadingIndicator()
            }
        } else {
            content
        }
    }
}

extension View {
    
    /// 로딩 인디케이터를 추가합니다.
    func loadingIndicator(isLoading: Bool) -> some View {
        modifier(LoadingIndicatorModifier(isLoading: isLoading))
    }
}
