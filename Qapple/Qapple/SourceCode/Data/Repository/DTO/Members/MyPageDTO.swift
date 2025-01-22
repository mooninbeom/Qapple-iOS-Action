//
//  MyPageDTO.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct MyPageDTO: Codable {
    let nickname: String
    let profileImage: String?
    let joinDate: String
    
    var toEntity: MyProfile {
        return MyProfile(
            nickname: nickname,
            profileImage: profileImage,
            joinDate: joinDate
        )
    }
}
