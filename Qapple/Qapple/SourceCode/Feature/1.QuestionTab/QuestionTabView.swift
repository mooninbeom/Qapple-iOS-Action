//
//  QuestionView.swift
//  Qapple
//
//  Created by 김민준 on 1/23/25.
//

import ComposableArchitecture
import SwiftUI

struct QuestionTabView: View {
    
    @Bindable var store: StoreOf<QuestionTabFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderTabBar(store: store)
            
            TabView(selection: $store.questionTab.sending(\.switchTab)) {
                TodayQuestionView(
                    store: store.scope(
                        state: \.todayQuestion,
                        action: \.todayQuestion
                    )
                )
                .tag(QuestionTabFeature.QuestionTab.todayQuestion)
                
                QuestionListView(
                    store: store.scope(
                        state: \.questionList,
                        action: \.questionList
                    )
                )
                .tag(QuestionTabFeature.QuestionTab.questionList)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

// MARK: - HeaderTabBar

private struct HeaderTabBar: View {
    
    let store: StoreOf<QuestionTabFeature>
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack(spacing: 28) {
                Spacer()
                
                Button("오늘의 질문") {
                    store.send(.todayQuestionTabButtonTapped)
                }
                .font(.pretendard(.semiBold, size: 14))
                .foregroundStyle(store.questionTab == .todayQuestion ? .main : .sub4)
                
                Button("질문 리스트") {
                    store.send(.questionListTabButtonTapped)
                }
                .font(.pretendard(.semiBold, size: 14))
                .foregroundStyle(store.questionTab == .questionList ? .main : .sub4)
                
                Spacer()
            }
            
            Button {
                store.send(.alertButtonTapped)
            } label: {
                Image(.noticeIcon)
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.white)
                    .frame(width: 24 , height: 24)
            }
            .padding(.trailing, 16)
        }
        .frame(height: 32)
        .background(backgroundColor)
    }
    
    private var backgroundColor: Color {
        switch store.questionTab {
        case .todayQuestion: return .second
        case .questionList: return .first
        }
    }
}

// MARK: - Preview

#Preview {
    QuestionTabView(store: Store(initialState: QuestionTabFeature.State()) {
        QuestionTabFeature()
    })
}
