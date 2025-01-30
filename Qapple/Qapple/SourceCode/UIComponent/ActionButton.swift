//
//  ActionButton.swift
//  Qapple
//
//  Created by 김민준 on 1/24/25.
//

import SwiftUI

struct ActionButton: View {
    
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    init(
        _ title: String,
        isActive: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isActive = isActive
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.pretendard(.semiBold, size: 18))
                .foregroundStyle(isActive ? .main : .disable)
                .frame(maxWidth: .infinity)
                .frame(height: 58)
        }
        .background(isActive ? .button : .secondaryButton)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .disabled(!isActive)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.first
            .ignoresSafeArea()
        
        ActionButton("버튼입니당", isActive: true) {}
    }
}
