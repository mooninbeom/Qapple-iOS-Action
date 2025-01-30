//
//  SearchBar.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import SwiftUI

// MARK: - SearchBar

struct LagacySearchBar: View {
    
    @Binding private(set) var searchText: String
    
    var body: some View {
        HStack(spacing: 6) {
            TextField("검색어를 입력해주세요", text: $searchText)
                .pretendard(.semiBold, 15)
        }
        .padding(14)
        .background(GrayScale.secondaryButton)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    LagacySearchBar(searchText: .constant(""))
}
