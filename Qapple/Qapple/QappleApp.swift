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
    
    private let mainStore = Store(initialState: MainFeature.State()) {
        MainFeature()
    }
    
    private let signUpFlowStore = Store(initialState: SignUpFlowFeature.State()) {
        SignUpFlowFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            if signUpFlowStore.isSignIn {
                MainView(store: mainStore)
            } else {
                SignUpFlowView(store: signUpFlowStore)
            }
        }
    }
}
