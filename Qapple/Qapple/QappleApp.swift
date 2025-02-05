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
    
    private let mainFlowStore = Store(initialState: .init()) {
        MainFlowFeature()
    }
    
    private let signUpFlowStore = Store(initialState: .init()) {
        SignUpFlowFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            if signUpFlowStore.isSignIn {
                MainFlowView(store: mainFlowStore)
            } else {
                SignUpFlowView(store: signUpFlowStore)
            }
        }
    }
}
