//
//  TermsAgreementView.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import SwiftUI

struct TermsAgreementView: View {
    
    let store: StoreOf<TermsAgreementFeature>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - Preview

#Preview {
    TermsAgreementView(store: Store(initialState: TermsAgreementFeature.State()) {
        TermsAgreementFeature()
    })
}
