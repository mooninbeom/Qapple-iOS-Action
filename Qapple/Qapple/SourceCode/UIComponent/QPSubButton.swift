//
//  QPSubButton.swift
//  Qapple
//
//  Created by 김민준 on 1/31/25.
//

import SwiftUI

struct QPSubButton: View {
    
    let title: String
    let isActive: Bool
    let tapAction: () -> Void
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            Text(title)
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(isActive ? .wh : .disable)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isActive ? .button : .secondaryButton)
                .cornerRadius(20, corners: .allCorners)
        }
        .disabled(!isActive)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.first.ignoresSafeArea()
        VStack(spacing: 24) {
            QPSubButton(
                title: "인증 확인",
                isActive: true,
                tapAction: {}
            )
            QPSubButton(
                title: "인증 확인",
                isActive: false,
                tapAction: {}
            )
        }
    }
}
