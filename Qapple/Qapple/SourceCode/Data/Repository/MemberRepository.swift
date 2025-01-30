//
//  MemberRepository.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import Foundation

struct MemberRepository {
    var signIn: (_ code: String, _ deviceToken: String) async throws -> Bool
}

// MARK: - DependencyKey

extension MemberRepository: DependencyKey {
    
    @Dependency(\.keychainService) static var keychainService
    
    static let liveValue = Self(
        signIn: { code, deviceToken in
            let url = try QappleAPI.Member.signIn(code: code, deviceToken: deviceToken).url()
            let response: BaseResponse<SignInDTO> = try await NetworkService.shared.get(url: url)
            try keychainService.createData(.accessToken, response.result.accessToken ?? "")
            try keychainService.createData(.refreshToken, response.result.refreshToken ?? "")
            return response.result.isMember
        }
    )
}

// MARK: - DependencyValues

extension DependencyValues {
    var memberRepository: MemberRepository {
        get { self[MemberRepository.self] }
        set { self[MemberRepository.self] = newValue }
    }
}

