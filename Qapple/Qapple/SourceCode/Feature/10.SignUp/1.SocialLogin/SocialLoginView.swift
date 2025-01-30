//
//  SocialLoginView.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import SwiftUI

struct SocialLoginView: View {
    
    let store: StoreOf<SocialLoginFeature>
    
    var body: some View {
        VStack {
            
        }
    }
}

// MARK: - Preview

#Preview {
    SocialLoginView(store: Store(initialState: SocialLoginFeature.State()) {
        SocialLoginFeature()
    })
}
