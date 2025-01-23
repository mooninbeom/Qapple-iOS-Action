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
            QuestionListView(store: Store(initialState: QuestionListFeature.State(), reducer: {
                QuestionListFeature()
            }))
        }
    }
}
