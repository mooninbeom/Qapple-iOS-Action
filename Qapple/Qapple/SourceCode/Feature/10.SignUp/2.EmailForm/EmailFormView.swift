//
//  EmailFormView.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import SwiftUI

struct EmailFormView: View {
    
    let store: StoreOf<EmailFormFeature>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - Preview

#Preview {
    EmailFormView(store: Store(initialState: EmailFormFeature.State()) {
        EmailFormFeature()
    })
}
