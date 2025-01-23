//
//  SignInDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct SignInDTO: Codable {
    let accessToken: String?
    let refreshToken: String?
    let isMember: Bool
}
