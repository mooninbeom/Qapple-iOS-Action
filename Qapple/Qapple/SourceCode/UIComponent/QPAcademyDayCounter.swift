//
//  QPAcademyDayCounter.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import SwiftUI

// MARK: - QPAcademyDayCounter

struct QPAcademyDayCounter: View {
    
    let academyEvents: [AcademyEvent]
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                if let currentEvent {
                    CurrentEventTitle(academyEvent: currentEvent)
                } else {
                    GraduateTitle()
                }
                
                Spacer()
                
                Image(.calendar)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 54, height: 54)
            }
            
            ProgressBar(academyEvent: currentEvent)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Background.second)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    /// 오늘 날짜를 기준으로 어떤 이벤트인지 반환합니다.
    private var currentEvent: AcademyEvent? {
        for event in academyEvents {
            if isTodayBetween(event.startDate, event.endDate) {
                return event
            }
        }
        
        return nil
    }
    
    /// 오늘 날짜가 두 날짜 사이에 포함되어 있는지 확인합니다.
    private func isTodayBetween(_ startDate: Date, _ endDate: Date) -> Bool {
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: .now)
        let today = calendar.date(from: todayComponents)!
        let startComponents = calendar.dateComponents([.year, .month, .day], from: startDate)
        let endComponents = calendar.dateComponents([.year, .month, .day], from: endDate)
        let start = calendar.date(from: startComponents)!
        let end = calendar.date(from: endComponents)!
        return today >= start && today <= end
    }
}

// MARK: - CurrentEventTitle

private struct CurrentEventTitle: View {
    
    let academyEvent: AcademyEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text(academyEvent.title)
                    .foregroundStyle(BrandPink.text)
                    .pretendard(.bold, 23)
                
                Text("종료까지")
                    .foregroundStyle(TextLabel.main)
                    .pretendard(.semiBold, 15)
                    .padding(.bottom, -2)
            }
            
            Text(dDayText)
                .foregroundStyle(TextLabel.main)
                .pretendard(.bold, 24)
        }
    }
    
    /// 종료 날짜까지 얼마나 남았는지 반환합니다.
    private var dayLeftUntilNextEvent: Int {
        let day = Calendar
            .current
            .dateComponents(
                [.year, .month, .day],
                from: .now,
                to: academyEvent.endDate
            )
            .day ?? 0
        
        return day + 1
    }
    
    /// D-Day 문자열을 반환합니다.
    private var dDayText: String {
        
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: .now)
        let today = calendar.date(from: todayComponents)!
        let endComponents = calendar.dateComponents([.year, .month, .day], from: academyEvent.endDate)
        let end = calendar.date(from: endComponents)!
        
        if today == end {
            return "D-Day"
        } else {
            return "D-\(dayLeftUntilNextEvent)"
        }
    }
}

// MARK: - GraduateTitle

private struct GraduateTitle: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text("Academy")
                    .foregroundStyle(BrandPink.text)
                    .pretendard(.bold, 23)
                
                Text("3기 수료!")
                    .foregroundStyle(TextLabel.main)
                    .pretendard(.semiBold, 15)
                    .padding(.bottom, -2)
            }
            
            Text("2024. 03. 04 ~ 2024. 12. 13")
                .foregroundStyle(TextLabel.main)
                .pretendard(.semiBold, 16)
        }
    }
}

// MARK: - ProgressBar

private struct ProgressBar: View {
    
    let academyEvent: AcademyEvent?
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(TextLabel.ph)
                    .frame(width: proxy.size.width)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(BrandPink.button)
                    .frame(width: proxy.size.width * progress)
            }
        }
        .frame(height: 16)
    }
    
    /// Progress 값을 반환합니다.
    private var progress: Double {
        guard let academyEvent else { return 1 }
        
        let total = Calendar
            .current
            .dateComponents(
                [.day],
                from: academyEvent.startDate,
                to: academyEvent.endDate
            )
            .day ?? 0
        
        return Double(total - dayLeftUntilNextEvent) / Double(total)
    }
    
    /// 종료 날짜까지 얼마나 남았는지 반환합니다.
    private var dayLeftUntilNextEvent: Int {
        guard let academyEvent else { return 0 }
        
        let difference = Calendar
            .current
            .dateComponents(
                [.day],
                from: .now,
                to: academyEvent.endDate
            )
        
        return difference.day ?? 0
    }
    
    /// ProgressBar에 적용할 그라디언트를 반환합니다.
    private var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 212/255, green: 105/255, blue: 249/255),
                Color(red: 244/255, green: 78/255, blue: 156/255),
                Color(red: 232/255, green: 44/255, blue: 201/255).opacity(0.84)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - Preview

#Preview {
    VStack {
        QPAcademyDayCounter(academyEvents: [.macro, .epilogue])
        QPAcademyDayCounter(academyEvents: [])
    }
}
