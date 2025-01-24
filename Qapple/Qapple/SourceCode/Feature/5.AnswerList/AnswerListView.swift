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
        Text("AnswerListView")
    }
}

// MARK: - Preview

#Preview {
    let question = Question(id: 0, content: "테스트 질문", publishedDate: .now, isAnswered: true, isLived: false)
    AnswerListView(store: Store(initialState: AnswerListFeature.State(question: question)) {
        AnswerListFeature()
    })
}
