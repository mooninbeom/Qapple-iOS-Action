//
//  RefreshTokenDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct RefreshTokenDTO: Codable {
    let accessToken: String
    let refreshToken: String
    
    var toEntity: RefreshToken {
        return RefreshToken(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
