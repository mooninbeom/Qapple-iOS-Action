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
    
    static let store = Store(initialState: RootFeature.State()) {
        RootFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(store: QappleApp.store)
        }
    }
}
