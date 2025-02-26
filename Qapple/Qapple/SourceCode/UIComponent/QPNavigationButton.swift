//
//  QPNavigationButton.swift
//  Qapple
//
//  Created by 김민준 on 1/24/25.
//

import SwiftUI

struct QPNavigationButton: View {
    
    enum ButtonType {
        case text(String, Color)
        case back
        case xmark
        case systemImage(String, Color)
        case image(ImageResource)
    }
    
    let buttonType: ButtonType
    let tapAction: () -> Void
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            switch buttonType {
            case let .text(string, color):
                Text(string)
                    .foregroundStyle(color)
                    .font(.pretendard(.medium, size: 17))
                
            case .back:
                Image(.customBackButtonIcon)
                    .resizable()
                    .frame(width: 24, height: 24)
                
            case .xmark:
                Image(.xmark)
                    .resizable()
                    .frame(width: 24, height: 24)
                
            case let .systemImage(string, color):
                Image(systemName: string)
                    .foregroundStyle(color)
                    .frame(width: 24, height: 24)
                
            case let .image(imageResource):
                Image(imageResource)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        QPNavigationButton(buttonType: .text("확인", .button)) {}
        QPNavigationButton(buttonType: .back) {}
        QPNavigationButton(buttonType: .xmark) {}
        QPNavigationButton(buttonType: .systemImage("pencil.circle.fill", .button)) {}
        QPNavigationButton(buttonType: .image(.appLogo)) {}
    }
}
