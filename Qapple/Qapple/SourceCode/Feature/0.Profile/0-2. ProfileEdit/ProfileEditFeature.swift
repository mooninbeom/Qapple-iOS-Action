//
//  ProfileEditFeature.swift
//  Qapple
//
//  Created by Simmons on 2/1/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ProfileEditFeature {
    @ObservableState
    struct State: Equatable {
//        @Presents var alert: AlertState<Action.Alert>?
        var nickname: String = ""
        var isLoading = false
    }
    
    enum Action {
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)
        
        enum Alert {
        }
        
        enum Delegate {
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert:
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}

// MARK: - ProfileEditAlert

extension AlertState where Action == ProfileEditFeature.Action.Alert {
    
}
