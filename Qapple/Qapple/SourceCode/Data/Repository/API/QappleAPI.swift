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
        
        case listOfMain
        case list(threshold: String?, pageSize: Int = 30)
        
//        case heart(qusetionId: Int64) // 질문 좋아요 사용하지 않음
        
        var rawValue: RawValue {
            switch self {
            case .listOfMain:
                appending(baseString: "main")
                
            case let .list(threshold, pageSize):
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
        
        case listOfProfile(threshold: Int?, pageSize: Int32 = 30)
        case delete(answerId: Int)
        case listOfQuestion(questionId: Int, threshold: Int?, pageSize: Int32 = 30)
        case register(questionId: Int, answer: String)
        
//        case fetch(answerId: Int64) // 답변 수정 사용하지 않음
//        case heart(answerId: Int64) // 답변 좋아요/취소 사용하지 않음
//        case getHeart(threshold: Int64?, pageSize: Int32 = 30) // 좋아요한 답변 조회 사용하지 않음
        
        var rawValue: RawValue {
            switch self {
            case let .listOfProfile(threshold, pageSize):
                appending(urlQueryItems: [
                    .init(key: "threshold", value: threshold),
                    .init(key: "pageSize", value: pageSize),
                ])
                
            case let .delete(answerId):
                appending(baseString: "\(answerId)")
                
            case let .listOfQuestion(questionId, threshold, pageSize):
                appending(baseString: "question/\(questionId)", urlQueryItems: [
                    .init(key: "threshold", value: threshold),
                    .init(key: "pageSize", value: pageSize),
                ])
                
            case let .register(questionId, answer):
                appending(baseString: "question/\(questionId)")
            }
        }
    }
    
    enum Notification: RawRepresentable, API {
        
        static let baseUrl = QappleAPI.baseUrl?
            .appendingPathComponent("notifications")
        
        case notification(threshold: Int?, pageSize: Int32 = 30)
        
        var rawValue: RawValue {
            switch self {
            case let .notification(threshold, pageSize):
                appending(urlQueryItems: [
                    .init(key: "threshold", value: threshold),
                    .init(key: "pageSize", value: pageSize),
                ])
                
            }
        }
    }
    
    enum Reports: RawRepresentable, API {
        
        static let baseUrl = QappleAPI.baseUrl?
            .appendingPathComponent("reports")
        
        case board(boardId: Int, boardReportType: String)
        case boardComment(boardCommentId: Int, boardCommentReportType: String)
        case answer(answerId: Int, reportType: String)
        
        var rawValue: RawValue {
            switch self {
            case let .board(boardId, boardReportType):
                appending(baseString: "board")
                
            case let .boardComment(boardCommentId, boardCommentReportType):
                appending(baseString: "board-comment")
                
            case let .answer(answerId, reportType):
                appending()
            }
        }
    }
    
    enum Token: RawRepresentable, API {
        
        static let baseUrl = QappleAPI.baseUrl?
            .appendingPathComponent("token")
        
        case refresh
        
        var rawValue: RawValue {
            switch self {
            case .refresh:
                appending(baseString: "refresh")
            }
        }
    }
}

