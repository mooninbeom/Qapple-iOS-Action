//
//  SignUpView.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import SwiftUI

struct SignUpView: View {
    
    let store: StoreOf<SignUpFeature>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - Preview

#Preview {
    SignUpView(store: Store(initialState: SignUpFeature.State()) {
        SignUpFeature()
    })
}
