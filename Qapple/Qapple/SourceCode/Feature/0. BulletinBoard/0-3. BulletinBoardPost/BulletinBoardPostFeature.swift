//
//  BulletinBoardPostFeature.swift
//  Qapple
//
//  Created by Simmons on 1/28/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BulletinBoardPostFeature {
    @ObservableState
    struct State: Equatable {
        var isLoading = false
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}
