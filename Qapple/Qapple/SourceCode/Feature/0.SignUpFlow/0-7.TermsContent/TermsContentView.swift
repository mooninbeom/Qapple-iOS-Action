//
//  TermsContentView.swift
//  Qapple
//
//  Created by 김민준 on 2/1/25.
//

import SwiftUI

struct TermsContentView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationBar(
                title: title,
                leadingView: {
                    NavigationButton(buttonType: .xmark) {
                        dismiss()
                    }
                }
            )
            .padding(.top, 16)
            
            ScrollView {
                Text(content)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(.sub2)
            }
            .padding(.top, 24)
            .padding(.horizontal, 24)
        }
        .background(Background.first)
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    TermsContentView(
        title: "약관 동의 콘텐츠",
        content: Constant.termsSummary
    )
}
