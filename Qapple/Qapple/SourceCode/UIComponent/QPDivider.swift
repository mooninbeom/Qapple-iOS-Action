//
//  QPDivider.swift
//  Qapple
//
//  Created by 김민준 on 10/5/24.
//

import SwiftUI

struct QPDivider: View {
    var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height: 0.6)
            .foregroundStyle(GrayScale.stroke)
    }
}

#Preview {
    QPDivider()
}
