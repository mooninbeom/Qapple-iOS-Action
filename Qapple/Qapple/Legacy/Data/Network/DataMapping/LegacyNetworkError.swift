//
//  LegacyNetworkError.swift
//  Capple
//
//  Created by 김민준 on 3/6/24.
//

import Foundation

enum LegacyNetworkError: Error {
    case badRequest
    case decodeFailed
    case cannotCreateURL
}
