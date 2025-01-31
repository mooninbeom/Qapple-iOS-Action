//
//  EmailFormFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture

@Reducer
struct EmailFormFeature {
    
    @ObservableState
    struct State: Equatable {
        var emailText = ""
        var isEmailTextValid = false
        var isLoading = false
    }
    
    enum Action: BindableAction {
        case backButtonTapped
        case sendMailButtonTapped
        case toggleLoading(Bool)
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { send in
                    await dismiss()
                }
                
            case .sendMailButtonTapped:
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case .binding(\.emailText):
                state.isEmailTextValid = !state.emailText.isEmpty
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
