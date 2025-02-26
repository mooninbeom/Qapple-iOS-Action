//
//  SignUpCompleteView.swift
//  Qapple
//
//  Created by 김민준 on 2/1/25.
//

import ComposableArchitecture
import SwiftUI

struct SignUpCompleteView: View {
    
    let store: StoreOf<SignUpCompleteFeature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            QPNavigationBar()
            
            Text("캐플에 오신 것을 환영합니다.\n당신의 이야기를 들려주세요!")
                .foregroundStyle(.main)
                .font(Font.pretendard(.bold, size: 24))
                .lineSpacing(6)
                .padding(.top, 32)
                .padding(.horizontal, 24)
            
            Spacer()
            
            QPActionButton("시작하기", isActive: true) {
                store.send(.startButtonTapped)
            }
            .padding(.bottom, 16)
            .padding(.horizontal, 24)
        }
        .background(.first)
        .navigationBarBackButtonHidden()
        .popGestureDisabled()
    }
}

// MARK: - Preview

#Preview {
    SignUpCompleteView(store: Store(initialState: .init()) {
        SignUpCompleteFeature()
    })
}
