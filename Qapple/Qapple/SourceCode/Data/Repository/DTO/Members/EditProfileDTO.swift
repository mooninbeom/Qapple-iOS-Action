//
//  EditProfileDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct EditProfileDTO: Codable {
    let nickname: String
    let profileImage: String?
    let memberId: Int
}

struct EditProfileRequest: Codable {
    let nickname: String
    let profileImage: String?
}
