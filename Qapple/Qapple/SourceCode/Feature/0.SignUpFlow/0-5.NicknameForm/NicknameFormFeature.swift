//
//  NicknameFormFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct NicknameFormFeature {
    
    @ObservableState
    struct State: Equatable {
        let emailText: String
        let nicknameLimit = 15
        var nicknameText = ""
        var isNicknameValidate = true
        var isNicknameDuplicate = false
        var isNicknameCheckComplete = false
        var isLoading = false
    }
    
    enum Action: BindableAction {
        case typeNicknameText(String)
        case backButtonTapped
        case nextButtonTapped
        case checkDuplicateButtonTapped
        case checkNicknameDuplicateResponse
        case nicknameFormComplete(email: String, nickname: String)
        case toggleLoading(Bool)
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.memberRepository) var memberRepository
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .typeNicknameText(text):
                state.nicknameText = text.slice(to: state.nicknameLimit)
                state.isNicknameValidate = state.nicknameText.checkSpecialChar
                state.isNicknameDuplicate = false
                state.isNicknameCheckComplete = false
                return .none
                
            case .backButtonTapped:
                return .run { send in
                    await dismiss()
                }
                
            case .nextButtonTapped:
                return .run { [email = state.emailText, nickname = state.nicknameText] send in
                    await send(.nicknameFormComplete(email: email, nickname: nickname))
                }
                
            case .checkDuplicateButtonTapped:
                return .run { [nickname = state.nicknameText] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let _ = try await memberRepository.checkNicknameDuplicate(nickname)
                        await send(.checkNicknameDuplicateResponse)
                    } catch {
                        HapticService.notification(type: .error)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .checkNicknameDuplicateResponse:
                state.isNicknameCheckComplete = true
                HapticService.notification(type: .success)
                return .none
                
            case .nicknameFormComplete:
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case .binding(\.nicknameText):
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
