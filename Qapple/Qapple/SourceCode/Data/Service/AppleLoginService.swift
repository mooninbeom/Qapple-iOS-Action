//
//  AppleLoginService.swift
//  Qapple
//
//  Created by 김민준 on 8/4/24.
//

import ComposableArchitecture
import AuthenticationServices

typealias AuthorizationCode = String

struct AppleLoginService {
    var requestLogin: (_ request: ASAuthorizationAppleIDRequest) -> Void
    var loginCompletion: (_ result: Result<ASAuthorization, Error>) async throws -> AuthorizationCode
}

// MARK: - DependencyKey

extension AppleLoginService: DependencyKey {
    static let liveValue = Self(
        requestLogin: { request in
            request.requestedScopes = [.fullName, .email]
        },
        loginCompletion: { result in
            switch result {
            case let .success(authResults):
                switch authResults.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    guard let authorizationCode = String(
                        data: appleIDCredential.authorizationCode ?? Data(),
                        encoding: .utf8) else {
                        throw AppleLoginError.failedGenerateAuthCode
                    }
                    return authorizationCode
                    
                default:
                    throw AppleLoginError.unknownError
                }
                
            case let .failure(error):
                throw error
            }
        }
    )
}

// MARK: - AppleLoginError

enum AppleLoginError: Error {
    case failedGenerateAuthCode
    case unknownError
}

// MARK: - DependencyValues

extension DependencyValues {
    var appleLoginService: AppleLoginService {
        get { self[AppleLoginService.self] }
        set { self[AppleLoginService.self] = newValue }
    }
}
