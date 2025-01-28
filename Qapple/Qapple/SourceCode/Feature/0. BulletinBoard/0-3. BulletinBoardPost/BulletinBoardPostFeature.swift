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
        var content: String = ""
        var fontSize: CGFloat = 48
        var textCountLimit = 150
    }
    
    enum Action {
        case cancelButtonTapped
        case setContent(String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .none
                
            case let .setContent(content):
                state.content = content
                
                if content.count > state.textCountLimit {
                    state.content = String(content.prefix(state.textCountLimit))
                } else {
                    state.content = content
                }
                
                switch state.content.count {
                case 0..<20: state.fontSize = 48
                case 20..<32: state.fontSize = 40
                case 32..<60: state.fontSize = 32
                case 60...100: state.fontSize = 24
                case 100...: state.fontSize = 17
                default: break
                }
                
                return .none
            }
        }
    }
}
