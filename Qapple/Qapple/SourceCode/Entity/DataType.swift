//
//  DataType.swift
//  Qapple
//
//  Created by 김민준 on 2/6/25.
//

import Foundation

/// Sheet, Report 등에서 사용하는 데이터 타입입니다.
enum DataType: Equatable {
    case myAnswer(AnswerOfProfile) // TODO: 추후 Answer로 통합!
    case answer(Answer)
    case bulletinBoard(BulletinBoard)
}
