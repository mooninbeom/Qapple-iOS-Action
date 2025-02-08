//
//  NetworkErrorAlert.swift
//  Qapple
//
//  Created by 김민준 on 2/8/25.
//

import ComposableArchitecture

extension AlertState {
    
    /// 네트워킹 실패 기본 Alert
    static var failedNetworking: Self {
        Self {
            TextState("이미 가입된 이메일이에요")
        } actions: {
            ButtonState(role: .cancel) {
                TextState("확인")
            }
        } message: {
            TextState("다른 이메일을 입력해주세요")
        }
    }
}
