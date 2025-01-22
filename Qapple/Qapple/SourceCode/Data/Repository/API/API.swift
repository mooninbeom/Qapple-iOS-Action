//
//  API.swift
//  Qapple
//
//  Created by Simmons on 1/21/25.
//

import Foundation

protocol API {
    static var baseUrl: URL? { get }
    func appending(baseString: String?, urlQueryItems: [APIQuery]) -> String
}

struct APIQuery {
    let key: String
    let value: Any?
}

/// API 에러 열거형
enum APIError: String, Error {
    case invalidBaseUrl = "유효하지 않은 BaseURL입니다."
}

extension API {
    
    func appending(baseString: String? = nil, urlQueryItems: [APIQuery] = []) -> String {
        
        // 1. 첫 번째 baseString
        var absoluteString = ""
        if let baseString = baseString {
            absoluteString = "/" + baseString + "?"
        } else {
            absoluteString = "?"
        }
        
        // 2. 나머지 QueryItem 추가
        for index in urlQueryItems.indices {
            let key = urlQueryItems[index].key
            
            // 3. value 값이 옵셔널이 아닐 시 QueryItem 추가
            if let value = urlQueryItems[index].value {
                absoluteString += "\(key)" + "=" + "\(value)" + "&"
            }
        }
        
        // 3. 마지막 불필요 특수 기호 삭제 및 반환
        absoluteString.removeLast()
        return absoluteString
    }
}


extension RawRepresentable where RawValue == String, Self: API {
    
    /// 프로토콜 준수용 생성자
    ///
    /// - 객체를 초기화하는 것이 아닌, 반환을 목적으로 하기에 항상 nil을 반환하는 것으로 대체.
    init?(rawValue: String) { nil }
    
    /// 원시값을 이용해 URL 타입으로 변환 후 반환합니다.
    func url() throws -> URL {
        
        // 기본 URL과 QueryItems(rawValue)을 합친 후 반환
        guard let baseUrl = Self.baseUrl,
              let url = URL(string: baseUrl.absoluteString + rawValue) else {
            throw APIError.invalidBaseUrl
        }
        
        return url
    }
}
