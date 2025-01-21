//
//  NetworkClient.swift
//  Qapple
//
//  Created by Simmons on 1/21/25.
//

import Foundation

protocol HTTPMethod {
    func signIn<T: Decodable, U: Encodable>(url: URL, body: U) async -> Result<T, Error>
    func get<T: Decodable>(url: URL) async -> Result<T, Error>
    func post<T: Decodable, U: Encodable>(url: URL, body: U) async -> Result<T, Error>
    func patch<T: Decodable, U: Encodable>(url: URL, body: U) async -> Result<T, Error>
    func delete<T: Decodable>(url: URL) async -> Result<T, Error>
}

/// 네트워킹을 수행할 클라이언트 객체
struct NetworkClient {
    
    /// GET 요청을 수행합니다.
    ///
    /// - 사전과제 내 네트워크 요청은 GET만 존재하므로 해당 함수만 구현
    func get<T>(url: URL) async throws -> T where T: Decodable {
        do {
            
            // 1. 네트워킹 수행
            let (data, response) = try await request(from: url)
            
            // 2. StatusCode 체크
            let statusCode = statusCode(response)
            try checkStatusCode(statusCode: statusCode)
            
            // 3. Decoding 및 반환
            let decodedData: T = try decoding(to: data)
            return decodedData
        } catch {
            throw error
        }
    }
}

// MARK: - URLSession

extension NetworkClient {
    
    /// URLSession을 통한 네트워킹을 수행합니다.
    ///
    /// - 커스텀 에러(NetworkError)를 반환하기 위해, 재사용을 염두에 두고 함수로 감싸주었습니다.
    func request(from url: URL) async throws -> (Data, URLResponse) {
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(
                "Bearer eyJhbGciOiJIUzUxMiJ9.eyJ0b2tlblR5cGUiOiJhY2Nlc3MiLCJtZW1iZXJJZCI6MTU0LCJyb2xlIjoiQUNBREVNSUVSIiwiaWF0IjoxNzM2OTE1ODMyLCJleHAiOjE3Mzc3Nzk4MzJ9.x2qe-8kZ3wyl0JGsNOfCmKoioEXoZS9H5liwG2A1bWDgeJk3JPkPPKm86Hbu5B_VD1UK5nJ_JxwQm1wTen04Hg",
                forHTTPHeaderField: "Authorization"
            )
            return try await URLSession.shared.data(for: request)
        } catch {
            throw NetworkError2.urlRequestFailure(urlString: url.absoluteString)
        }
    }
}

// MARK: - Status Code

extension NetworkClient {
    
    /// URLResponse의 StatusCode를 반환합니다.
    func statusCode(_ response: URLResponse) -> Int {
        
        // StatusCode 옵셔널 바인딩 실패 시, 실패 StatusCode(400) 반환
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            return 400
        }
        
        return statusCode
    }
    
    /// StatusCode의 상태값이 성공인지 확인합니다.
    func checkStatusCode(statusCode: Int) throws {
        
        // 성공 범위 안에 들지 못하면 에러 던지기
        let successStatusCodeRange = 200...299
        if !successStatusCodeRange.contains(statusCode) {
            throw NetworkError2.invalidResponse(statusCode: statusCode)
        }
    }
}

// MARK: - Decoding

extension NetworkClient {
    
    /// Data를 Decoding 후 반환합니다.
    ///
    /// - 커스텀 에러(NetworkError)를 반환하기 위해, 재사용을 염두에 두고 함수로 감싸주었습니다.
    func decoding<T: Decodable>(to data: Data) throws -> T {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError2.decodingFailure(data: data)
        }
    }
}

/// 네트워킹에서 발생할 수 있는 에러를 정의합니다.
enum NetworkError2: Error {
    
    /// URLReuqest 함수 호출에 실패했습니다.
    case urlRequestFailure(urlString: String)
    
    /// 유효하지 않은 Response입니다.
    case invalidResponse(statusCode: Int)
    
    /// Decoding에 실패했습니다.
    case decodingFailure(data: Data)
}
