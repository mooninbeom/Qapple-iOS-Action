//
//  QappleApp.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/9/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct QappleApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @StateObject private var authViewModel: AuthViewModel = .init()
    
    var body: some Scene {
        WindowGroup {
            // MainView(authViewModel: authViewModel)
            TodayQuestionView(
                store: Store(
                    initialState: TodayQuestionFeature.State(
                        questionState: .creating,
                        todayQuestion: .init(
                            id: 0,
                            content: "테스트 질문",
                            publishedDate: .now,
                            isAnswered: false,
                            isLived: false
                        )
                    ),
                    reducer: {
                        TodayQuestionFeature()
                    }
                )
            )
        }
    }
}
