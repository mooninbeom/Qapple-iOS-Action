//
//  SocialLoginFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import AuthenticationServices

@Reducer
struct SocialLoginFeature {
    
    @ObservableState
    struct State: Equatable {
        var isLoading = false
    }
    
    enum Action {
        case appleLoginOnRequest(ASAuthorizationAppleIDRequest)
        case appleLoginOnCompletion(Result<ASAuthorization, Error>)
    }
    
    @Dependency(\.appleLoginService) var appleLoginService
    @Dependency(\.keychainService) var keychainService
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .appleLoginOnRequest(request):
                appleLoginService.requestLogin(request)
                return .none
                
            case let .appleLoginOnCompletion(result):
                return .run { send in
                    do {
                        let authCode = try await appleLoginService.loginCompletion(result)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
