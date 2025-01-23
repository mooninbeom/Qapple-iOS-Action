//
//  BulletinBoardFeature.swift
//  Qapple
//
//  Created by Simmons on 1/23/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BulletinBoardFeature {
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action {
        case onAppear
        case refresh
        case boardButtonTapped
        case seeMoreButtonTapped
        case searchButtonTapped
        case notificationButtonTapped
        case postBoardButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case .refresh:
                return .none
                
            case .boardButtonTapped:
                return .none
                
            case .seeMoreButtonTapped:
                return .none
                
            case .searchButtonTapped:
                return .none
                
            case .notificationButtonTapped:
                return .none
                
            case .postBoardButtonTapped:
                return .none
            }
        }
    }
}

