//
//  WriteAnswerView.swift
//  Qapple
//
//  Created by 김민준 on 1/24/25.
//

import ComposableArchitecture
import SwiftUI

struct WriteAnswerView: View {
    
    @Bindable var store: StoreOf<WriteAnswerFeature>
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            WriteAnswerNavigationBar(store: store)
            
            Text(questionContent)
                .font(.pretendard(.bold, size: 23))
                .foregroundStyle(.subText)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding([.top, .horizontal], 24)
            
            Spacer()
            
            AnswerTextField(store: store, isTextFieldFocused: $isTextFieldFocused)
                .padding(.horizontal, 24)
            
            Spacer()
            
            Bottom(store: store)
                .padding(.horizontal, 24)
        }
        .background(.first)
        .navigationBarBackButtonHidden()
        .popGestureDisabled()
        .loadingIndicator(isLoading: store.isLoading)
        .alert($store.scope(state: \.alert, action: \.alert))
        .onTapGesture {
            isTextFieldFocused.toggle()
        }
        .sheet(item: $store.scope(
            state: \.sheet?.anonymityNotice,
            action: \.sheet.anonymityNotice
        )) { _ in
            AnonymityNoticeSheet()
        }
    }
    
    /// Q. 색상을 설정 후 반환하는 AttributedString
    private var questionContent: AttributedString {
        var questionMark = AttributedString("Q. ")
        questionMark.foregroundColor = .text
        let attributeText = AttributedString(stringLiteral: store.question.content)
        return questionMark + attributeText
    }
}

// MARK: - WriteAnswerNavigationBar

private struct WriteAnswerNavigationBar: View {
    
    let store: StoreOf<WriteAnswerFeature>
    
    var body: some View {
        NavigationBar(
            title: "답변하기",
            leadingView: {
                NavigationButton(buttonType: .text("취소", .wh)) {
                    store.send(.dismissButtonTapped)
                }
            },
            trailingView: {
                NavigationButton(buttonType: .text("완료", completeButtonColor)) {
                    store.send(.completeButtonTapped)
                }
                .disabled(store.answerText.isEmpty || store.isLoading)
            }
        )
    }
    
    /// 완료 버튼 색상
    private var completeButtonColor: Color {
        store.answerText.isEmpty ? .disable : .text
    }
}

// MARK: - AnswerTextField

private struct AnswerTextField: View {
    
    @Bindable var store: StoreOf<WriteAnswerFeature>
    @FocusState.Binding var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            if store.answerText.isEmpty {
                Placeholder()
            }
            
            TextField(text: $store.answerText, axis: .vertical) {}
                .foregroundStyle(.wh)
                .font(.pretendard(.semiBold, size: store.answerTextFontSize))
                .focused($isTextFieldFocused)
                .autocorrectionDisabled()
                .multilineTextAlignment(.center)
                .onChange(of: store.answerText) { _, value in
                    store.send(.typeAnswerText(value))
                }
        }
        .onTapGesture {
            isTextFieldFocused = true
        }
    }
    
    /// 답변 작성 전 플레이스홀더
    private func Placeholder() -> some View {
        VStack(spacing: 16) {
            Text("자유롭게 생각을\n작성해주세요")
                .font(.pretendard(.semiBold, size: 48))
            
            Text("* 부적절하거나 불쾌감을 줄 수 있는\n콘텐츠는 제재를 받을 수 있어요")
                .font(.pretendard(.medium, size: 16))
        }
        .foregroundStyle(TextLabel.ph)
        .padding(.horizontal, 24)
        .multilineTextAlignment(.center)
        .lineSpacing(6)
    }
    
    /// 답변 글자 수에 따른 적응형 폰트 사이즈를 반환합니다.
    private func adaptiveFontSize(from answerText: String) -> CGFloat {
        switch answerText.count {
        case 0..<20: 48
        case 20..<32: 40
        case 32..<60: 32
        case 60...100: 24
        case 100...: 17
        default: 48
        }
    }
}

// MARK: - Bottom

private struct Bottom: View {
    
    let store: StoreOf<WriteAnswerFeature>
    
    var body: some View {
        HStack {
            Button("익명이 보장되나요?") {
                store.send(.anonymityNoticeButtonTapped)
            }
            .font(.pretendard(.semiBold, size: 12))
            .foregroundStyle(.text)
            
            Spacer()
            
            Text("\(store.answerText.count)/\(store.textLimit)")
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(.sub3)
        }
    }
}

// MARK: - Preview

#Preview {
    let question = Question(id: 0, content: "테스트 질문", publishedDate: .now, isAnswered: false, isLived: true)
    WriteAnswerView(store: Store(initialState: WriteAnswerFeature.State(question: question)) {
        WriteAnswerFeature()
    })
}
