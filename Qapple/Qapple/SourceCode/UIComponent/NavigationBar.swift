//
//  NavigationBar.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/25/24.
//

import SwiftUI

struct NavigationBar<Leading: View, Center: View, Trailing: View>: View {
    
    let title: String?
    let backgroundColor: Color
    let leadingView: Leading
    let centerView: Center
    let trailingView: Trailing
    
    init(
        title: String? = nil,
        backgroundColor: Color = .clear,
        @ViewBuilder leadingView: (() -> Leading) = { EmptyView() },
        @ViewBuilder centerView: (() -> Center) = { EmptyView() },
        @ViewBuilder trailingView: (() -> Trailing) = { EmptyView() }
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.leadingView = leadingView()
        self.centerView = centerView()
        self.trailingView = trailingView()
    }
    
    var body: some View {
        ZStack {
            HStack {
                leadingView
                Spacer()
                trailingView
            }
            
            HStack {
                Spacer()
                if let title = title {
                    Text(title)
                        .font(.pretendard(.semiBold, size: 17))
                        .foregroundStyle(.wh)
                } else {
                    centerView
                }
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(backgroundColor)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.first.ignoresSafeArea()
        NavigationBar(
            title: "테스트"
        )
    }
}
