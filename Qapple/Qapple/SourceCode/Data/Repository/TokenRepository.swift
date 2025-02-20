//
//  TokenRepository.swift
//  Qapple
//
//  Created by Simmons on 2/20/25.
//

import ComposableArchitecture
import QappleRepository
import Foundation

struct TokenRepository {
    var refreshToken: () async throws -> RefreshToken
}

// MARK: - DependencyKey

extension TokenRepository: DependencyKey {
    
    @Dependency(\.keychainService) static var keychainService
    
    private static let repositoryService = RepositoryService.shared
    
    private static func accessToken() throws -> String {
        try keychainService.fetchData(.accessToken)
    }
    
    static var liveValue = Self (
        refreshToken: {
            var response = try await TokenAPI.refresh(
                server: repositoryService.server,
                accessToken: accessToken()
            )
            return RefreshToken(
                accessToken: response.accessToken,
                refreshToken: response.refreshToken
            )
        }
    )
}

// MARK: - DependencyValues

extension DependencyValues {
    var tokenRepository: TokenRepository {
        get { self[TokenRepository.self] }
        set { self[TokenRepository.self] = newValue }
    }
}
