//
//  NetworkClient.swift
//  Qapple
//
//  Created by Simmons on 1/21/25.
//

import ComposableArchitecture
import Foundation

/// 네트워킹을 수행할 클라이언트 객체
struct NetworkService {
    
    /// NetworkClient 싱글톤 객체
    static let shared = NetworkService()
    private init() {}
    
    @Dependency(\.keychainService.fetchData) var fetchData
    
    func signIn<T: Decodable>(url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: request)
        return try decodeResponse(data: data, response: response)
    }
    
    /// GET 요청을 수행합니다.
    func get<T>(url: URL) async throws -> T where T: Decodable {
        do {
            
            // 네트워킹 수행
            let (data, response) = try await request(url: url, method: "GET")
            return try decodeResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
    
    /// POST 요청을 수행합니다.
    func post<T: Decodable, U: Encodable>(url: URL, body: U) async throws -> T {
        do {
            
            // 네트워킹 수행
            let (data, response) = try await request(url: url, body: body, method: "POST")
            
            return try decodeResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
    
    /// PATCH 요청을 수행합니다.
    func patch<T: Decodable, U: Encodable>(url: URL, body: U) async throws -> T {
        do {
            
            // 네트워킹 수행
            let (data, response) = try await request(url: url, body: body, method: "PATCH")
            
            return try decodeResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
    
    /// DELETE 요청을 수행합니다.
    func delete<T>(url: URL) async throws -> T where T: Decodable {
        do {
            
            // 네트워킹 수행
            let (data, response) = try await request(url: url, method: "DELETE")
            
            return try decodeResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
    
}

// MARK: - URLSession

extension NetworkService {
    
    /// URLSession을 통한 네트워킹을 수행합니다.
    ///
    /// - 커스텀 에러(NetworkError)를 반환하기 위해, 재사용을 염두에 두고 함수로 감싸주었습니다.
    func request(url: URL, body: Encodable? = nil, method: String) async throws -> (Data, URLResponse) {
        do {
            let accessToken = "Bearer \(try fetchData(.accessToken))"
            var request = URLRequest(url: url)
            request.httpMethod = method
            request.setValue(accessToken, forHTTPHeaderField: "Authorization")
            
            // Body가 있는 경우 Content-Type 추가 및 Body 인코딩
            if let body = body {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONEncoder().encode(body)
            }
            
            return try await URLSession.shared.data(for: request)
        } catch {
            throw NetworkError.urlRequestFailure(urlString: url.absoluteString)
        }
    }
}

// MARK: - Status Code

extension NetworkService {
    
    /// URLResponse의 StatusCode를 반환합니다.
    func statusCode(_ response: URLResponse) -> Int {
        
        // StatusCode 옵셔널 바인딩 실패 시, 실패 StatusCode(400) 반환
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            return 400
        }
        
        return statusCode
    }
    
    /// StatusCode의 상태값이 성공인지 확인합니다.
    func checkStatusCode(response: URLResponse, data: Data) throws {
        let baseResponse: NetworkError.BaseResponse? = try? decoding(to: data)
        let statusCode = statusCode(response)
        let successStatusCodeRange = 200...299
        if !successStatusCodeRange.contains(statusCode) {
            throw NetworkError.invalidResponse(
                urlString: response.url?.absoluteString ?? "",
                statusCode: statusCode,
                message: baseResponse?.message
            )
        }
    }
}

// MARK: - Decoding

extension NetworkService {
    
    /// Data를 Decoding 후 반환합니다.
    ///
    /// - 커스텀 에러(NetworkError)를 반환하기 위해, 재사용을 염두에 두고 함수로 감싸주었습니다.
    func decoding<T: Decodable>(to data: Data) throws -> T {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingFailure(type: T.self)
        }
    }
    
    /// 응답을 검증하고 데이터를 디코딩한 결과를 반환합니다.
    func decodeResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        // StatusCode 체크
        try checkStatusCode(response: response, data: data)
        
        // Decoding 및 반환
        return try decoding(to: data)
    }
}

// MARK: - Network Error

/// 네트워킹에서 발생할 수 있는 에러를 정의합니다.
enum NetworkError: Error {
    
    /// URLReuqest 함수 호출에 실패했습니다.
    case urlRequestFailure(urlString: String)
    
    /// 유효하지 않은 Response입니다.
    case invalidResponse(urlString: String, statusCode: Int, message: String?)
    
    /// Decoding에 실패했습니다.
    case decodingFailure(type: Decodable.Type)
    
    struct BaseResponse: Decodable {
        let timeStamp: String
        let code: String
        let message: String
    }
}
