//
//  StringSlicing+.swift
//  Qapple
//
//  Created by 김민준 on 1/31/25.
//

import Foundation

extension String {
    
    /// 지정한 숫자까지 문자열을 앞에서 잘라 반환합니다.
    func slice(to int: Int) -> Self {
        String(self.prefix(int))
    }
}
