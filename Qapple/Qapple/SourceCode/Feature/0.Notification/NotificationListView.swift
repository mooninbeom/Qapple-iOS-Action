//
//  NotificationListView.swift
//  Qapple
//
//  Created by 문인범 on 1/26/25.
//

import SwiftUI
import ComposableArchitecture


/**
 Notification 뷰(푸쉬 알림 뷰)
 */
struct NotificationListView: View {
    @Bindable var store: StoreOf<NotificationFeature> = .init(
        initialState: NotificationFeature.State()
    ) {
        NotificationFeature()
            ._printChanges()
    }
    
    var body: some View {
        ZStack {
            Color(Background.first).ignoresSafeArea()
            
            NotificationContentView(store: store)
            
            if store.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.primary)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            store.send(.onAppear)
        }
        .alert($store.scope(state: \.alert, action: \.alert))
        
    }
}


// MARK: - NotificationContentView
private struct NotificationContentView: View {
    let store: StoreOf<NotificationFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                leadingView: { CustomNavigationBackButton(buttonType: .arrow) {
                    // TODO: Navigation 적용
                }},
                principalView: {
                    Text("알림")
                        .font(Font.pretendard(.semiBold, size: 17))
                        .foregroundStyle(TextLabel.main)
                },
                trailingView: {},
                backgroundColor: Background.first)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(enumerated(store.notifications), id: \.offset) { index, notification in
                        NotificationCell(notification: notification) {
                            // TODO: 탭 액션 제공 (신고된 글인지 여부, 답변된 질문인지 여부)
                            store.send(.notificationCellTapped(index))
                        }
                        .onAppear {
                            store.send(.onPagenationCellAppear(index))
                        }
                        Separator()
                    }
                    
                    Text("알림은 7일간 보관됩니다.")
                        .font(Font.pretendard(.medium, size: 14))
                        .foregroundStyle(TextLabel.sub4)
                        .padding(.top, 16)
                }
            }
            .refreshable {
                store.send(.onRefresh)
            }
        }
        .onAppear {
            // TODO: 단일 post 불러오기
        }
    }
}


#Preview {
    NotificationListView()
}
