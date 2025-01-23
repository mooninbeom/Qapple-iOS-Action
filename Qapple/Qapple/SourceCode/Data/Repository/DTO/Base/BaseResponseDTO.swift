//
//  BaseResponseDTO.swift
//  Qapple
//
//  Created by Simmons on 1/21/25.
//

import Foundation

struct BaseResponse<ResultType: Decodable>: Decodable {
    let timeStamp: String
    let code: String
    let message: String
    let result: ResultType
}
