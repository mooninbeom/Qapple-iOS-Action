//
//  ProfileFeature.swift
//  Qapple
//
//  Created by Simmons on 1/30/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ProfileFeature {
    @ObservableState
    struct State: Equatable {
        var nickname: String = ""
        var joinDate: String = ""
        var Image: String?
        var isLoading = false
    }
    
    enum Action {
        case editProfileButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .editProfileButtonTapped:
                // TODO: Navigation 처리
                return .none
            }
        }
    }
}
