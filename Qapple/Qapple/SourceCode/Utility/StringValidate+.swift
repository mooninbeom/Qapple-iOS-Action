//
//  StringValidate+.swift
//  Qapple
//
//  Created by 김민준 on 2/1/25.
//

import Foundation

extension String {
    
    /// 특수 기호 체크
    var checkSpecialChar: Bool {
        let pattern = "^[가-힣a-zA-Z\\s]*$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let range = NSRange(location: 0, length: self.utf16.count)
            if regex.firstMatch(in: self, options: [], range: range) != nil {
                return true
            }
        }
        return false
    }
}
