//
//  MyProfile.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct MyProfile: Identifiable, Equatable {
    let id = UUID()
    let nickname: String
    let profileImage: String?
    let joinDate: String
}
