//
//  RootView.swift
//  Qapple
//
//  Created by 김민준 on 1/20/25.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    
    @Bindable var store: StoreOf<RootFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            TabView {
                QuestionTabView(store: store.scope(state: \.questionTab, action: \.questionTab))
                    .tabItem {
                        Image(systemName: "questionmark.bubble.fill")
                        Text("오늘의 질문")
                    }
            }
            .tint(.button)
            .fixedTabBarBackground(color: .first)
        } destination: { store in
            switch store.case {
            case let .writeAnswer(store): WriteAnswerView(store: store)
            case let .answerList(store): AnswerListView(store: store)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    RootView(store: Store(initialState: RootFeature.State()) {
        RootFeature()
    })
}
