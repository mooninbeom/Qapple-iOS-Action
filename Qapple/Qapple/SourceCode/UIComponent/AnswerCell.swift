//
//  AnswerCell.swift
//  Qapple
//
//  Created by 김민준 on 1/21/25.
//

import SwiftUI

struct AnswerCell: View {
    
    enum State {
        case normal(index: Int)
        case written
    }
    
    let answer: Answer
    let state: State
    let seeMoreAction: () -> Void
    
    var body: some View {
        switch state {
        case let .normal(index):
            if answer.isReported {
                ReportedCell(
                    answer: answer,
                    author: author(index: index)
                )
            } else {
                NormalCell(
                    answer: answer,
                    author: author(index: index),
                    seeMoreAction: seeMoreAction
                )
            }
            
        case .written:
            NormalCell(
                answer: answer,
                author: answer.authorNickname,
                seeMoreAction: seeMoreAction
            )
        }
    }
    
    /// 작성자 이름 문자열
    private func author(index: Int) -> String {
        if answer.isResignMember { return "(알 수 없음)" }
        else { return "러너 \(index + 1)" }
    }
}

// MARK: - NormalCell

private struct NormalCell: View {
    
    let answer: Answer
    let author: String
    let seeMoreAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            
            Header()
                .padding(.top, 18)
                .padding(.horizontal, 16)
            
            Content()
                .padding(.bottom, 16)
                .padding(.horizontal, 16)
        }
        .background(.first)
    }
    
    private func Header() -> some View {
        HStack(spacing: 0) {
            Image(.profileDummy)
                .resizable()
                .frame(width: 28, height: 28)
            
            Text(author)
                .pretendard(.semiBold, 14)
                .foregroundStyle(.icon)
                .padding(.leading, 8)
            
            Text(answer.publishedDate.timeAgo)
                .pretendard(.regular, 14)
                .foregroundStyle(.sub4)
                .padding(.leading, 6)
            
            Spacer()
            
            Button {
                seeMoreAction()
            } label: {
                Image(systemName: "ellipsis")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .foregroundStyle(.icon)
            }
        }
    }
    
    private func Content() -> some View {
        HStack(spacing: 8) {
            Circle()
                .foregroundStyle(.clear)
                .frame(width: 28, height: 28)
            
            Text(answer.content)
                .pretendard(.medium, 16)
                .foregroundStyle(.main)
                .padding(.top, 2)
        }
    }
}

// MARK: - ReportedCell

private struct ReportedCell: View {
    
    @State private var isReportContentShow = false
    
    let answer: Answer
    let author: String
    
    var body: some View {
        Group {
            if isReportContentShow {
                ReportShowView()
            } else {
                ReportHideView()
            }
        }
        .opacity(0.5)
    }
    
    private func ReportHideView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            
            HStack(alignment: .top) {
                Text("신고 되어 내용을 검토 중인 답변이에요")
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(.sub3)
                
                Spacer()
                
                Button {
                    isReportContentShow.toggle()
                } label: {
                    Text("답변 보기")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(.text)
                }
            }
            .frame(height: 28)
            .padding(.top, 18)
            .padding(.horizontal, 16)
            
            HStack {
                Text("주의) 부적절한 콘텐츠가 포함될 수 있어요")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(.sub4)
                
                Spacer()
            }
            .padding(.bottom, 24)
            .padding(.horizontal, 16)
        }
        .background(.first)
    }
    
    private func ReportShowView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            
            Header()
                .padding(.top, 18)
                .padding(.horizontal, 16)
            
            Content()
                .padding(.bottom, 0)
                .padding(.horizontal, 16)
        }
        .background(.first)
        .padding(.bottom, 16)
    }
    
    private func Header() -> some View {
        HStack(spacing: 0) {
            Image(.profileDummy)
                .resizable()
                .frame(width: 28, height: 28)
            
            Text(author)
                .pretendard(.semiBold, 14)
                .foregroundStyle(.icon)
                .padding(.leading, 8)
            
            Text(answer.publishedDate.timeAgo)
                .pretendard(.regular, 14)
                .foregroundStyle(.sub4)
                .padding(.leading, 6)
            
            Spacer()
            
            Button {
                isReportContentShow.toggle()
            } label: {
                Text("답변 숨기기")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(.text)
            }
        }
    }
    
    private func Content() -> some View {
        HStack(spacing: 8) {
            Circle()
                .foregroundStyle(.clear)
                .frame(width: 28, height: 28)
            
            Text(answer.content)
                .pretendard(.medium, 16)
                .foregroundStyle(.main)
                .padding(.top, 2)
        }
    }
}

// MARK: - Preview

#Preview {
    let answers = [
        Answer(
            id: 0,
            content: "일반 답변",
            authorNickname: "시몬스",
            publishedDate: .now,
            isReported: false,
            isMine: false,
            isResignMember: false
        ),
        Answer(
            id: 1,
            content: "내 답변",
            authorNickname: "한톨",
            publishedDate: .now,
            isReported: false,
            isMine: true,
            isResignMember: false
        ),
        Answer(
            id: 2,
            content: "탈퇴한 답변",
            authorNickname: "무니",
            publishedDate: .now,
            isReported: false,
            isMine: false,
            isResignMember: true
        ),
        Answer(
            id: 3,
            content: "신고된 답변",
            authorNickname: "리버",
            publishedDate: .now,
            isReported: true,
            isMine: false,
            isResignMember: false
        )
    ]
    ZStack {
        Color.first.ignoresSafeArea()
        
        VStack(alignment: .leading, spacing: 0) {
            AnswerCell(answer: answers[0], state: .normal(index: 0)) {}
            AnswerCell(answer: answers[1], state: .normal(index: 1)) {}
            AnswerCell(answer: answers[2], state: .normal(index: 2)) {}
            AnswerCell(answer: answers[3], state: .normal(index: 3)) {}
            AnswerCell(answer: answers[1], state: .written) {}
        }
    }
}
