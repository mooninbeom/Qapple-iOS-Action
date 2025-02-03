//
//  MainFlowView.swift
//  Qapple
//
//  Created by 김민준 on 1/20/25.
//

import ComposableArchitecture
import SwiftUI

struct MainFlowView: View {
    
    @Bindable var store: StoreOf<MainFlowFeature>
    
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
                
                ProfileView(store: store.scope(state: \.profileTab, action: \.profileTab))
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("내 정보")
                    }
            }
            .tint(.button)
            .fixedTabBarBackground(color: .first)
        } destination: { store in
            switch store.case {
            case let .notificationList(store): NotificationListView(store: store)
            case let .writeAnswer(store): WriteAnswerView(store: store)
            case let .completeAnswer(store): CompleteAnswerView(store: store)
            case let .answerList(store): AnswerListView(store: store)
            case let .bulletinBoard(store): BulletinBoardView(store: store)
            case let .bulletinBoardSearch(store): EmptyView() // TODO: store 분리 필요
            case let .bulletinBoardPost(store): BulletinBoardPostView(store: store)
            case let .comment(store): CommentView(store: store)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    MainFlowView(store: Store(initialState: MainFlowFeature.State()) {
        MainFlowFeature()
    })
}
