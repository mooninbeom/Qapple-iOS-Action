//
//  KeychainService.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import Foundation

struct KeychainService {
    
    enum KeychainType: String {
        case accessToken
        case refreshToken
        case userId
        case deviceToken
    }
    
    var fetchData: (_ type: KeychainType) throws -> String
    var createData: (_ type: KeychainType, _ dataString: String) throws -> Void
}

// MARK: - DependencyKey

extension KeychainService: DependencyKey {
    static let liveValue = Self(
        fetchData: { type in
            // 1. 키체인에서 검색할 query
            let searchQuery: [CFString: Any] = [
                kSecClass: kSecClassKey,
                kSecAttrType: type.rawValue,
                kSecReturnAttributes: true,
                kSecReturnData: true
            ]
            
            // 2. 검색 결과를 담을 변수 생성
            var result: CFTypeRef?
            
            // 3. 키체인에 쿼리를 이용한 검색 및 반환
            let status = SecItemCopyMatching(searchQuery as CFDictionary, &result)
            
            // 4. 검색 결과가 잘 들어왔는지 확인
            guard status != errSecItemNotFound else {
                throw KeyChainError.notFound
            }
            
            guard status == errSecSuccess else {
                throw KeyChainError.unHandledError(status: status)
            }
            
            // 5. 검색 결과를 Dictionary로 변환
            guard let existingItem = result as? [String: Any],
                  let tokenData = existingItem[kSecValueData as String] as? Data,
                  let dataString = String(data: tokenData, encoding: .utf8)
            else {
                throw KeyChainError.undexpectedData
            }
            
            // 6. 최종 데이터 반환
            return dataString
        },
        createData: { type, dataString in
            // 1. String을 Data로 변환
            let data = dataString.data(using: .utf8)!
            
            // 2. 데이터 생성용 쿼리
            let createQuery: [CFString: Any] = [
                kSecClass: kSecClassKey,
                kSecAttrType: type.rawValue,
                kSecValueData: data
            ]
            
            // 3. 키체인에 쿼리를 이용해 추가
            let status = SecItemAdd(createQuery as CFDictionary, nil)
            
            // 4. 키체인 추가가 잘 되었는지 확인
            if status == errSecSuccess {
                // print("키체인 생성 성공")
            } else if status == errSecDuplicateItem {
                try updateData(type, data: data)
            } else {
                throw KeyChainError.unHandledError(status: status)
            }
        }
    )
}

// MARK: - Helper

extension KeychainService {
    
    /// 키체인 내 데이터를 업데이트합니다.
    private static func updateData(_ type: KeychainType, data: Data) throws {
        
        // 1. 기존 키체인을 찾기 위한 쿼리
        let originalQuery: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrType: type.rawValue
        ]
        
        // 2. 업데이트할 데이터를 담고 있는 쿼리
        let updateQuery: [CFString: Any] = [
            kSecValueData: data
        ]
        
        // 3. 키체인에 쿼리를 이용해 업데이트
        let status = SecItemUpdate(originalQuery as CFDictionary, updateQuery as CFDictionary)
        
        // 4. 키체인 업데이트가 잘 되었는지 확인
        if status == errSecSuccess {
        } else {
            throw KeyChainError.unHandledError(status: status)
        }
    }
}

// MARK: - DependencyValues

extension DependencyValues {
    var keychainService: KeychainService {
        get { self[KeychainService.self] }
        set { self[KeychainService.self] = newValue }
    }
}

// MARK: - KeychainError

extension KeychainService {
    
    enum KeyChainError: Error {
        case notFound
        case undexpectedData
        case unHandledError(status: OSStatus)
    }
}
