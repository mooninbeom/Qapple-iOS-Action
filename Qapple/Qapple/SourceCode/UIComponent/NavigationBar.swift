//
//  NavigationBar.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/25/24.
//

import SwiftUI

struct NavigationBar<Leading: View, Center: View, Trailing: View>: View {
    let leadingView: Leading
    let centerView: Center
    let trailingView: Trailing
    var backgroundColor: Color
    
    init(
        @ViewBuilder leadingView: (() -> Leading) = { EmptyView() },
        @ViewBuilder centerView: (() -> Center) = { EmptyView() },
        @ViewBuilder trailingView: (() -> Trailing) = { EmptyView() },
        backgroundColor: Color = .first
    ) {
        self.leadingView = leadingView()
        self.centerView = centerView()
        self.trailingView = trailingView()
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        ZStack {
            HStack {
                leadingView
                Spacer()
                trailingView
            }
            centerView
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .background(backgroundColor)
    }
}

// MARK: - Preview

#Preview {
    NavigationBar(
        leadingView: { Text("Leading").foregroundColor(.white) },
        centerView: { Text("Center").foregroundColor(.white) },
        trailingView: { Text("Trailing").foregroundColor(.text) }
    )
}
