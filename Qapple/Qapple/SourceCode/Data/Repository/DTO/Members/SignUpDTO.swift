//
//  SignUpDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct SignUpDTO: Codable {
    let accessToken: String?
    let refreshToken: String?
}

struct SignUpRequest: Codable {
    let signUpToken: String
    let email: String
    let nickname: String
    let profileImage: String?
    let deviceToken: String
}
