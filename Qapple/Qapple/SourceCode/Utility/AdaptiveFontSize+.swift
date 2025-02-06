//
//  AdaptiveFontSize+.swift
//  Qapple
//
//  Created by Simmons on 2/5/25.
//

import Foundation

func adaptiveFontSize(from text: String) -> CGFloat {
    switch text.count {
    case 0..<20: 48
    case 20..<32: 40
    case 32..<60: 32
    case 60...100: 24
    case 100...: 17
    default: 48
    }
}
