//
//  MyAnswerCell.swift
//  Qapple
//
//  Created by Simmons on 2/2/25.
//

import SwiftUI

struct MyAnswerCell: View {
    
    let myAnswer: AnswerOfProfile
    let index: Int
    let seeMoreAction: () -> Void
    
    var body: some View {
        NormalCell(
            myAnswer: myAnswer,
            index: index,
            seeMoreAction: seeMoreAction
        )
    }
}

// MARK: - NormalCell

private struct NormalCell: View {
    
    let myAnswer: AnswerOfProfile
    let index: Int
    let seeMoreAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if index > 0 {
                Divider()
            }
            
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
            
            Text(myAnswer.nickname)
                .pretendard(.semiBold, 14)
                .foregroundStyle(GrayScale.icon)
                .padding(.leading, 8)
            
            Text(myAnswer.writeAt.timeAgo)
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
            
            Text(myAnswer.content)
                .pretendard(.medium, 16)
                .foregroundStyle(.main)
                .padding(.top, 2)
        }
    }
}

// MARK: - Preview

#Preview {
    MyAnswerCell(
        myAnswer: AnswerOfProfile(
            id: 0,
            answerId: 1,
            writerId: 2,
            nickname: "simmons",
            content: "test1",
            writeAt: .now
        ),
        index: 1
    ){}
}

