//
//  CommentReportView.swift
//  Qapple
//
//  Created by 문인범 on 1/21/25.
//

import SwiftUI
import ComposableArchitecture

struct CommentReportView: View {
    @Bindable var store: StoreOf<CommentReportFeature>
    
    init(commentId: Int) {
        self.store = .init(
            initialState: CommentReportFeature.State(commentId: commentId)) {
                CommentReportFeature()
            }
    }
    
    private let reportList = [
        "불법촬영물 등의 유통",
        "상업적 광고 및 판매",
        "게시판 성격에 부적절함",
        "욕설/비하",
        "정당/정치인 비하 및 선거운동",
        "유출/사칭/사기",
        "낚시/놀림/도배"
    ]
    
    var body: some View {
        ZStack {
            Color(Background.first)
                .ignoresSafeArea()
            
            VStack {
                NavigationBar(
                    title: "신고하기",
                    leadingView: {
                        NavigationButton(buttonType: .back) {
                            // TODO: 네비게이션 수정 필요
                        }
                    }
                )
                
                VStack(alignment: .leading) {
                    ForEach(Array(self.reportList.enumerated()), id: \.offset) { index, report in
                        Button {
                            store.send(.reportListItemTapped(index))
                            HapticService.shared.notification(type: .warning)
                        } label: {
                            Text(report)
                                .font(.pretendard(.medium, size: 16))
                                .foregroundStyle(.wh)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 48)
                                .background(Background.first)
                        }
                        .disabled(store.isLoading)
                    }
                    
                    Spacer()
                        .frame(height: 32)
                    
                    Text("* 캐플은 모든 사용자가 안전하고 쾌적한 환경에서 서비스를 이용할 수 있도록 최선을 다하고 있어요. 그러나 이를 악용하여 다른 사용자에게 피해를 주는 경우, 제재가 가해질 수 있어요")
                        .font(.pretendard(.regular, size: 14))
                        .foregroundStyle(TextLabel.sub3)
                        .lineSpacing(8)
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            
            if store.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
        .navigationBarBackButtonHidden()
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}



#Preview {
    CommentReportView(commentId: 0)
}
