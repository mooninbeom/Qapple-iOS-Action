//
//  CommentReportView.swift
//  Qapple
//
//  Created by 문인범 on 1/21/25.
//

import SwiftUI
import ComposableArchitecture

struct CommentReportView: View {
    @Bindable var store: StoreOf<CommentReportFeature> = .init(
        initialState: CommentReportFeature.State(commentId: 0)) {
            CommentReportFeature()
        }
    
    var body: some View {
        ZStack {
            Color(Background.first)
                .ignoresSafeArea()
            
            VStack {
                CustomNavigationBar(
                    leadingView:{
                        CustomNavigationBackButton(buttonType: .arrow)  {
                            // TODO: 네비게이션 수정 필요
                        }
                    },
                    principalView: {
                        Text("신고하기")
                            .font(Font.pretendard(.semiBold, size: 15))
                            .foregroundStyle(TextLabel.main)
                    },
                    trailingView: {},
                    backgroundColor: .clear
                )
                
                VStack(alignment: .leading) {
                    ForEach(Array(store.reportList.enumerated()), id: \.offset) { index, report in
                        Button {
                            store.send(.reportButtonTapped(index))
//                            reportType = CommentReportType.allCases[index]
//                            isReportAlertPresented.toggle()
                            HapticService.notification(type: .warning)
//                            print("신고타입: \(reportType)")
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
        // TODO: 답변 신고 Alert
//        .alert("답변을 신고하시겠어요?", isPresented: $isReportAlertPresented) {
//            Button("취소", role: .cancel) {}
//            Button("신고하기", role: .destructive) {
//                Task {
//                    self.isLoading = true
//                    await self.reportComment()
//                    self.isLoading = false
//                    sendUpdateViewNotification()
//                    self.isReportCompleteAlertPresented.toggle()
//                }
//            }
//        }
        // TODO: 신고 완료 Alert
//        .alert("신고가 완료됐어요", isPresented: $isReportCompleteAlertPresented) {
//            Button("확인", role: .none) {
//                // TODO: 네비게이션 수정 필요
//            }
//        } message: {
//            Text("신고한 댓글은 블라인드 처리 되며, 관리자 검토 후 최대 24시간 이내에 조치 될 예정이에요")
//        }
    }
}
