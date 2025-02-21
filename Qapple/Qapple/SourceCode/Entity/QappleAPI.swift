//
//  QappleAPI.swift
//  Qapple
//
//  Created by 김민준 on 2/21/25.
//

import Foundation

enum QappleAPI {
    
    typealias TotalCount = Int
    
    struct PaginationInfo: Equatable {
        var threshold: String
        var hasNext: Bool
    }
    
    struct Token {
        let accessToken: String
        let refreshToken: String
    }
}
