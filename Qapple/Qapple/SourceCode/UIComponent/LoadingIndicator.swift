//
//  LoadingIndicator.swift
//  Qapple
//
//  Created by 김민준 on 1/28/25.
//

import SwiftUI

struct LoadingIndicator: View {
    var body: some View {
        ZStack {
            Color.first
                .opacity(0.8)
                .ignoresSafeArea()
            
            CircularLoadig()
        }
    }
}

// MARK: - CircularLoadig

private struct CircularLoadig: View {
    
    @State private var rotationAngle = 0.0
    
    private let ringSize: CGFloat = 58
    private let lineWidth: CGFloat = 6
    private let color: Color = .button
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: ringSize, height: ringSize)
            
            Circle()
                .frame(width: lineWidth, height: lineWidth)
                .foregroundColor(color)
                .offset(x: ringSize / 2)
        }
        .rotationEffect(.degrees(rotationAngle))
        .padding(.horizontal, 80)
        .padding(.vertical, 50)
        .onAppear {
            withAnimation(.linear(duration: 1.5)
                .repeatForever(autoreverses: false)) {
                    rotationAngle = 360.0
                }
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Image(.appLogo)
            .resizable()
            .frame(width: 56, height: 56)
        
        LoadingIndicator()
    }
}
