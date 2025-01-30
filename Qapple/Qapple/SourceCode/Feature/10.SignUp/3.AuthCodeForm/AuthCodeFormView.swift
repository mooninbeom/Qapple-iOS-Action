//
//  AuthCodeFormView.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import SwiftUI

struct AuthCodeFormView: View {
    
    let store: StoreOf<AuthCodeFormFeature>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - Preview

#Preview {
    AuthCodeFormView(store: Store(initialState: AuthCodeFormFeature.State()) {
        AuthCodeFormFeature()
    })
}
