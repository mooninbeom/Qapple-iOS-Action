//
//  AnonymityView.swift
//  Qapple
//
//  Created by Simmons on 1/28/25.
//

import SwiftUI
import ComposableArchitecture

struct AnonymityView: View {
    
    let store: StoreOf<AnonymityFeature>
    
    var body: some View {
        ZStack {
            Color(Background.first)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Spacer().frame(height: 12)
                
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: 56, height: 4)
                        .foregroundStyle(GrayScale.secondaryButton)
                    Spacer()
                }
                
                Spacer().frame(height: 32)
                
                Text("캐플에게 질문이 있어요! 🧐")
                    .font(.pretendard(.bold, size: 20))
                    .foregroundStyle(TextLabel.main)
                
                Spacer().frame(height: 40)
                
                VStack(alignment: .leading, spacing: 32) {
                    NoticeCell(
                        question: "캐플은 어떻게 탄생하게 되었나요?",
                        content: "캐플은 러너 200명의 다채로운 모습을 서로 더 많이, 더 쉽게 알아가고자 만들어졌어요."
                    )
                    
                    NoticeCell(
                        question: "캐플의 답변은 익명성이 보장되나요?",
                        content: "익명 보장을 위해 캐플 서버에는 단 한가지 개인정보, 이메일만을 보관하고 있어요."
                    )
                    
                    NoticeCell(
                        question: "이메일을 통해 사용자를 알 수 있지 않을까요?",
                        content: "이메일 또한 철저히 암호화되어 캐플 개발자 또한 열람이 불가능해요!"
                    )
                }
                
                Spacer()
                    .frame(height: 48)
                
                Text("자유롭게 생각을 표현하고 러너들을 알아가봐요!")
                    .font(.pretendard(.bold, size: 17))
                    .foregroundStyle(BrandPink.text)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(6)
                
                Spacer()
                
                ActionButton("확인", isActive: .constant(true)) {
                    store.send(.confirmButtonTapped)
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - NoticeCell
private struct NoticeCell: View {
    
    let question: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Text("Q.")
                    .foregroundStyle(BrandPink.text)
                Text(question)
                    .foregroundStyle(TextLabel.main)
            }
            .font(.pretendard(.bold, size: 17))
            
            Text(content)
            .font(.pretendard(.medium, size: 15))
            .foregroundStyle(TextLabel.sub2)
            .multilineTextAlignment(.leading)
            .lineSpacing(4)
        }
    }
}

#Preview {
    AnonymityView(store: Store(initialState: AnonymityFeature.State()) {
        AnonymityFeature()
    })
}
