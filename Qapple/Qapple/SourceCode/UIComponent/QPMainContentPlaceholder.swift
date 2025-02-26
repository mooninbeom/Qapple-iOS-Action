//
//  QPMainContentPlaceholder.swift
//  Qapple
//
//  Created by 김민준 on 2/7/25.
//

import SwiftUI

struct QPMainContentPlaceholder: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("자유롭게 생각을\n작성해주세요")
                .font(.pretendard(.semiBold, size: 48))
            
            Text("* 부적절하거나 불쾌감을 줄 수 있는\n콘텐츠는 제재를 받을 수 있어요")
                .font(.pretendard(.medium, size: 16))
        }
        .foregroundStyle(TextLabel.ph)
        .padding(.horizontal, 24)
        .multilineTextAlignment(.center)
        .lineSpacing(6)
    }
}

#Preview {
    QPMainContentPlaceholder()
}
