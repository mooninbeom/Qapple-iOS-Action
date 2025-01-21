//
//  TokenKey.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

extension QappleRepository {
    
    static func makeRefreshToken() -> () async throws -> RefreshToken {
        return {
            let url = try QappleAPI.Token.refresh.url()
            let response: BaseResponse<RefreshTokenDTO> = try await networkClient.get(url: url)
            return response.result.toEntity
        }
    }
}
