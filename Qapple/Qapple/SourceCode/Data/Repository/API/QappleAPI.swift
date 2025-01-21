//
//  QappleAPI.swift
//  Qapple
//
//  Created by Simmons on 1/21/25.
//

import Foundation

enum QappleAPI {
    
    typealias PaginationInfo = (threshold: String, hasNext: Bool)
    
    private static let baseUrl = URL(string: "http://api.capple.shop:8080")
    
    enum Question: RawRepresentable, API {
        
        static let baseUrl = QappleAPI.baseUrl?
            .appendingPathComponent("questions")
        
        case mainList
        case allList(threshold: String?, pageSize: Int = 30)
//        case heart(qusetionId: Int64) // 질문 좋아요 사용하지 않음
        
        var rawValue: RawValue {
            switch self {
            case .mainList:
                appending(baseString: "main")
            case let .allList(threshold, pageSize):
                appending(urlQueryItems: [
                    .init(key: "threshold", value: threshold),
                    .init(key: "pageSize", value: pageSize)
                ])
            }
        }
    }
    
    enum Answer: RawRepresentable, API {
        static let baseUrl = QappleAPI.baseUrl?
            .appendingPathComponent("answers")
        
        case listOfQuestion(questionId: Int64, threshold: String?, pageSize: Int32 = 30)
        
        var rawValue: RawValue {
            switch self {
            case let .listOfQuestion(questionId, threshold, pageSize):
                appending(baseString: "question/\(questionId)", urlQueryItems: [
                    .init(key: "threshold", value: threshold),
                    .init(key: "pageSize", value: pageSize),
                ])
            }
        }
    }
}

