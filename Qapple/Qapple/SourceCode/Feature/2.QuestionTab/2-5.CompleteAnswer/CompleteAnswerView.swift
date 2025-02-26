//
//  CompleteAnswerView.swift
//  Qapple
//
//  Created by 김민준 on 1/27/25.
//

import ComposableArchitecture
import SwiftUI

struct CompleteAnswerView: View {
    
    let store: StoreOf<CompleteAnswerFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            QPNavigationBar()
            
            HStack {
                Text("답변 등록이 완료됐어요!\n이제 다른 답변을 확인해볼까요?")
                    .foregroundStyle(.main)
                    .font(.pretendard(.bold, size: 24))
                    .lineSpacing(6)
                
                Spacer()
            }
            .padding(.top, 32)
            
            Spacer()
            
            Image(.questionComplete)
                .resizable()
                .frame(width: 240, height: 240)
                .padding(.bottom, 48)
            
            Spacer()
            
            QPActionButton("확인", isActive: true) {
                store.send(.confirmButtonTapped(store.question))
            }
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 24)
        .background(.first)
        .navigationBarBackButtonHidden()
        .popGestureEnabled(false)
    }
}

// MARK: - Preview

#Preview {
    CompleteAnswerView(store: Store(initialState: CompleteAnswerFeature.State(question: .initialState)) {
        CompleteAnswerFeature()
    })
}
