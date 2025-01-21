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
    
    enum Answer: RawRepresentable, API {
        static let baseUrl = QappleAPI.baseUrl?
            .appendingPathComponent("answers")
        
        case listOfProfile(threshold: Int?, pageSize: Int32 = 30)
        case delete(answerId: Int)
        case listOfQuestion(questionId: Int, threshold: Int?, pageSize: Int32 = 30)
        case post(questionId: Int)
        
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
                
            case let .post(questionId):
                appending(baseString: "question/\(questionId)")
            }
        }
    }
    
    enum Board: RawRepresentable, API {
        
        static let baseUrl = QappleAPI.baseUrl?
            .appendingPathComponent("boards")
        
        case list(threshold: Int?, pageSize: Int32 = 30)
        case post
        case single(boardId: Int)
        case delete(boardId: Int)
        case like(boardId: Int)
        case search(keyword: String?, threshold: Int?, pageSize: Int32 = 30)
        
        var rawValue: RawValue {
            switch self {
            case let .list(threshold, pageSize):
                appending(urlQueryItems: [
                    .init(key: "threshold", value: threshold),
                    .init(key: "pageSize", value: pageSize),
                ])
                
            case .post:
                appending()
                
            case let .single(boardId):
                appending(baseString: "\(boardId)")
                
            case let .delete(boardId):
                appending(baseString: "\(boardId)")
                
            case let .like(boardId):
                appending(baseString: "\(boardId)")
                
            case let .search(keyword, threshold, pageSize):
                appending(urlQueryItems: [
                    .init(key: "keyword", value: keyword),
                    .init(key: "threshold", value: threshold),
                    .init(key: "pageSize", value: pageSize),
                ])
            }
        }
    }
    
    enum Question: RawRepresentable, API {
        
        static let baseUrl = QappleAPI.baseUrl?
            .appendingPathComponent("questions")
        
        case listOfMain
        case list(threshold: String?, pageSize: Int32 = 30)
        
//        case heart(qusetionId: Int64) // 질문 좋아요 사용하지 않음
        
        var rawValue: RawValue {
            switch self {
            case .listOfMain:
                appending(baseString: "main")
                
            case let .list(threshold, pageSize):
                appending(urlQueryItems: [
                    .init(key: "threshold", value: threshold),
                    .init(key: "pageSize", value: pageSize),
                ])
            }
        }
    }
    
    enum BoardComment: RawRepresentable, API {
        
        static let baseUrl = QappleAPI.baseUrl?
            .appendingPathComponent("board-comments")
        
        case list(boardId: Int, threshold: Int?, pageSize: Int32 = 30)
        case delete(commentId: Int)
        case post(boardId: Int)
        case like(commentId: Int)
        
        var rawValue: RawValue {
            switch self {
            case let .list(boardId, threshold, pageSize):
                appending(baseString: "\(boardId)", urlQueryItems: [
                    .init(key: "threshold", value: threshold),
                    .init(key: "pageSize", value: pageSize),
                ])
                
            case let .delete(commentId):
                appending(baseString: "\(commentId)")
                
            case let .post(boardId):
                appending(baseString: "board/\(boardId)")
                
            case let .like(commentId):
                appending(baseString: "heart/\(commentId)")
            }
        }
    }
    
    enum Notification: RawRepresentable, API {
        
        static let baseUrl = QappleAPI.baseUrl?
            .appendingPathComponent("notifications")
        
        case list(threshold: Int?, pageSize: Int32 = 30)
        
        var rawValue: RawValue {
            switch self {
            case let .list(threshold, pageSize):
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
        
        case board
        case boardComment
        case answer
        
        var rawValue: RawValue {
            switch self {
            case .board:
                appending(baseString: "board")
                
            case .boardComment:
                appending(baseString: "board-comment")
                
            case .answer:
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

