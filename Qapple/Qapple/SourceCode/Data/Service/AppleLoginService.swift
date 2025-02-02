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
    var autoLogin: () async throws -> Void
}

// MARK: - DependencyKey

extension AppleLoginService: DependencyKey {
    
    @Dependency(\.keychainService) static var keychainService
    
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
                    try keychainService.createData(.userId, appleIDCredential.user)
                    return authorizationCode
                    
                default:
                    throw AppleLoginError.unknownError
                }
                
            case let .failure(error):
                throw error
            }
        },
        autoLogin: {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let userId = try keychainService.fetchData(.userId)
            let credentialState = try await appleIDProvider.credentialState(forUserID: userId)
            switch credentialState {
            case .authorized:
                return
                
            case .revoked:
                throw AppleLoginError.autoLoginFailed("revoked")
                
            case .notFound:
                throw AppleLoginError.autoLoginFailed("notFound")
                
            case .transferred:
                throw AppleLoginError.autoLoginFailed("transferred")
                
            @unknown default:
                throw AppleLoginError.autoLoginFailed("unknown")
            }
        }
    )
}

// MARK: - AppleLoginError

enum AppleLoginError: Error {
    case failedGenerateAuthCode
    case autoLoginFailed(String)
    case unknownError
}

// MARK: - DependencyValues

extension DependencyValues {
    var appleLoginService: AppleLoginService {
        get { self[AppleLoginService.self] }
        set { self[AppleLoginService.self] = newValue }
    }
}
