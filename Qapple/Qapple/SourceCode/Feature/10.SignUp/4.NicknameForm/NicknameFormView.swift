//
//  NicknameFormView.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import SwiftUI

struct NicknameFormView: View {
    
    let store: StoreOf<NicknameFormFeature>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - Preview

#Preview {
    NicknameFormView(store: Store(initialState: NicknameFormFeature.State()) {
        NicknameFormFeature()
    })
}
