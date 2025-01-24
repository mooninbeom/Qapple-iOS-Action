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
                BulletinBoardView(store: store.scope(state: \.bulletinBoardTab, action: \.bulletinBoardTab))
                    .tabItem {
                        Image(systemName: "list.clipboard.fill")
                        Text("게시판")
                    }
            }
            .tint(.button)
            .fixedTabBarBackground(color: .first)
        } destination: { store in
            switch store.case {
            default: EmptyView()
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
