//
//  AcademyEvent.swift
//  Qapple
//
//  Created by 김민준 on 11/27/24.
//

import Foundation

struct AcademyEvent: Equatable {
    let title: String
    let startDate: Date
    let endDate: Date
    
    /// 매크로 날짜를 포함한 이벤트 Entity를 반환합니다.
    static var macro: AcademyEvent {
        
        var start = DateComponents()
        start.year = 2024
        start.month = 9
        start.day = 2
        
        var end = DateComponents()
        end.year = 2024
        end.month = 11
        end.day = 29
        
        return AcademyEvent(
            title: "Macro",
            startDate: Calendar.current.date(from: start)!,
            endDate: Calendar.current.date(from: end)!
        )
    }
    
    /// 에필로그 날짜를 포함한 이벤트 Entity를 반환합니다.
    static var epilogue: AcademyEvent {
        
        var start = DateComponents()
        start.year = 2024
        start.month = 12
        start.day = 2
        
        var end = DateComponents()
        end.year = 2024
        end.month = 12
        end.day = 13
        
        return AcademyEvent(
            title: "Epilogue",
            startDate: Calendar.current.date(from: start)!,
            endDate: Calendar.current.date(from: end)!
        )
    }
}
