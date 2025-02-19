//
//  RepositoryService.swift
//  Qapple
//
//  Created by 김민준 on 2/19/25.
//

import Foundation
import QappleRepository

final class RepositoryService {
    
    static let shared = RepositoryService()
    private init() {}
    
    private var _server: Server?
    
    /// 현재 서버를 반환합니다.
    ///
    /// 기본 서버가 설정되어 있어야 합니다.(configureServer)
    var server: Server {
        guard let server = _server else {
            fatalError("기본 서버가 설정되지 않았습니다. configureServer(to:) 함수를 통해 기본 서버를 설정해주세요.")
        }
        return server
    }
    
    /// 기본 서버를 설정합니다.
    func configureServer(to server: Server) {
        guard _server == nil else {
            fatalError("서버는 한 번만 설정할 수 있습니다.")
        }
        _server = server
    }
}
