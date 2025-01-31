//
//  QPSubButton.swift
//  Qapple
//
//  Created by 김민준 on 1/31/25.
//

import SwiftUI

struct QPSubButton: View {
    
    enum Variation {
        case primary
        case secondary
    }
    
    let title: String
    let isActive: Bool
    let variation: Variation
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
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(backgroundColor)
                        .stroke(strokeColor, lineWidth: 1)
                )
                .cornerRadius(20, corners: .allCorners)
        }
        .disabled(!isActive)
    }
    
    private var backgroundColor: Color {
        guard isActive else { return .bk }
        switch variation {
        case .primary: return .button
        case .secondary: return .secondaryButton
        }
    }
    
    private var strokeColor: Color {
        switch variation {
        case .primary: .clear
        case .secondary: isActive ? .button : .clear
        }
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
                variation: .primary,
                tapAction: {}
            )
            QPSubButton(
                title: "인증 확인",
                isActive: false,
                variation: .primary,
                tapAction: {}
            )
            QPSubButton(
                title: "인증 확인",
                isActive: true,
                variation: .secondary,
                tapAction: {}
            )
            QPSubButton(
                title: "인증 확인",
                isActive: false,
                variation: .secondary,
                tapAction: {}
            )
        }
    }
}
