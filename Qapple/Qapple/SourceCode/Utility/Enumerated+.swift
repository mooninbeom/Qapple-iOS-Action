//
//  Enumerated+.swift
//  Qapple
//
//  Created by 김민준 on 1/21/25.
//

import Foundation

/// enumerated Type으로 변환 후 반환합니다.
func enumerated<T>(_ array: [T]) -> [(offset: Int, element: T)] {
    array.enumerated().map { ($0.offset, $0.element) }
}
