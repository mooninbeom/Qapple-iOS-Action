//
//  AnswerListView.swift
//  Qapple
//
//  Created by 김민준 on 1/24/25.
//

import ComposableArchitecture
import SwiftUI

struct AnswerListView: View {
    
    let store: StoreOf<AnswerListFeature>
    
    var body: some View {
        VStack {
            AnswerListNavigationBar(store: store)
        }
        .background(.first)
    }
}

// MARK: - AnswerListNavigationBar

private struct AnswerListNavigationBar: View {
    
    let store: StoreOf<AnswerListFeature>
    
    var body: some View {
        NavigationBar(
            title: "답변 리스트",
            leadingView: {
                NavigationButton(buttonType: .back) {
                    store.send(.backButtonTapped)
                }
            }
        )
    }
}

// MARK: - Preview

#Preview {
    let question = Question(id: 0, content: "테스트 질문", publishedDate: .now, isAnswered: true, isLived: false)
    AnswerListView(store: Store(initialState: AnswerListFeature.State(question: question)) {
        AnswerListFeature()
    })
}
