//
//  WriteAnswerView.swift
//  Qapple
//
//  Created by 김민준 on 1/24/25.
//

import ComposableArchitecture
import SwiftUI

struct WriteAnswerView: View {
    
    let store: StoreOf<WriteAnswerFeature>
    
    var body: some View {
        Text("WriteAnswerView")
    }
}

// MARK: - Preview

#Preview {
    let question = Question(id: 0, content: "테스트 질문", publishedDate: .now, isAnswered: false, isLived: true)
    WriteAnswerView(store: Store(initialState: WriteAnswerFeature.State(question: question)) {
        WriteAnswerFeature()
    })
}
