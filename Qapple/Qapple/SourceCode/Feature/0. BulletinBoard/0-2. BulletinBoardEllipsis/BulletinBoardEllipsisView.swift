//
//  BulletinBoardEllipsisView.swift
//  Qapple
//
//  Created by Simmons on 1/23/25.
//

import SwiftUI
import ComposableArchitecture

// MARK: - BulletinBoardSeeMoreSheetView

struct BulletinBoardEllipsisView: View {
    
    @Bindable var store: StoreOf<BulletinBoardEllipsisFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    HapticService.notification(type: .success)
                    if store.isMine {
                        store.send(.deleteButtonTapped)
                    } else {
                        store.send(.reportButtonTapped)
                    }
                } label: {
                    Text(store.isMine ? "삭제하기" : "신고하기")
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(Context.warning)
                }
                .padding(.leading, 20)
                
                Spacer()
            }
        }
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

// MARK: - Preview

#Preview {
    BulletinBoardEllipsisView(store: Store(initialState: BulletinBoardEllipsisFeature.State()) {
        BulletinBoardEllipsisFeature()
    })
}
