//
//  QPTextField.swift
//  Qapple
//
//  Created by 김민준 on 1/31/25.
//

import SwiftUI

struct QPTextField<TopTrailing: View, BottomTrailing: View>: View {
    
    enum State {
        case `default`
        case inValid
    }
    
    @Binding var textString: String
    @FocusState.Binding var isTextFieldFocused: Bool
    
    let title: String
    let placeholder: String
    let helperText: String
    let state: State
    let topTrailingView: TopTrailing
    let bottomTrailingView: BottomTrailing
    
    init(
        textString: Binding<String>,
        isTextFieldFocused: FocusState<Bool>.Binding,
        title: String,
        placeholder: String,
        helperText: String,
        state: State,
        @ViewBuilder topTrailingView: () -> TopTrailing = { EmptyView() },
        @ViewBuilder bottomTrailingView: () -> BottomTrailing = { EmptyView() }
    ) {
        self._textString = textString
        self._isTextFieldFocused = isTextFieldFocused
        self.title = title
        self.placeholder = placeholder
        self.helperText = helperText
        self.state = state
        self.topTrailingView = topTrailingView()
        self.bottomTrailingView = bottomTrailingView()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .foregroundStyle(.sub3)
                .font(.pretendard(.medium, size: 14))
                .frame(height: 10)
            
            ZStack(alignment: .leading) {
                if textString.isEmpty {
                    Text(placeholder)
                        .foregroundStyle(TextLabel.ph)
                        .font(Font.pretendard(.semiBold, size: 20))
                        .frame(height: 14)
                }
                
                HStack(spacing: 0) {
                    TextField(text: $textString) {}
                        .foregroundStyle(.main)
                        .font(.pretendard(.semiBold, size: 20))
                        .frame(height: 14)
                        .autocorrectionDisabled()
                        .focused($isTextFieldFocused)
                    
                    Spacer()
                    
                    topTrailingView
                }
                .frame(height: 14)
            }
            .padding(.top, 24)
            
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(strokeColor)
                .padding(.top, 20)
            
            HStack(alignment: .top) {
                Text(helperText)
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(helperTextColor)
                    .lineSpacing(6)
                
                Spacer()
                
                bottomTrailingView
            }
            .padding(.top, 16)
        }
    }
    
    private var strokeColor: Color {
        guard !textString.isEmpty else { return TextLabel.ph }
        switch state {
        case .default: return .wh
        case .inValid: return .warning
        }
    }
    
    private var helperTextColor: Color {
        switch state {
        case .default:
            return .sub3
            
        case .inValid:
            return textString.isEmpty ? .sub3 : .warning
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.first.ignoresSafeArea()
        VStack(spacing: 40) {
            QPTextField(
                textString: .constant(""),
                isTextFieldFocused: FocusState<Bool>().projectedValue,
                title: "이메일",
                placeholder: "텍스트를 입력해주세요",
                helperText: "* 아카데미 계정 아이디를 입력해주세요",
                state: .default,
                topTrailingView: {
                    Text(Constant.academyEmail)
                        .foregroundStyle(TextLabel.ph)
                        .font(.pretendard(.semiBold, size: 14))
                        .frame(height: 8)
                }
            )
            
            QPTextField(
                textString: .constant(""),
                isTextFieldFocused: FocusState<Bool>().projectedValue,
                title: "이메일",
                placeholder: "텍스트를 입력해주세요",
                helperText: "* 아카데미 계정 아이디를 입력해주세요",
                state: .inValid,
                topTrailingView: {
                    Text(Constant.academyEmail)
                        .foregroundStyle(TextLabel.ph)
                        .font(.pretendard(.semiBold, size: 14))
                        .frame(height: 8)
                }
            )
            
            QPTextField(
                textString: .constant("테스트 텍스트"),
                isTextFieldFocused: FocusState<Bool>().projectedValue,
                title: "이메일",
                placeholder: "텍스트를 입력해주세요",
                helperText: "* 아카데미 계정 아이디를 입력해주세요",
                state: .default,
                topTrailingView: {
                    Text(Constant.academyEmail)
                        .foregroundStyle(TextLabel.ph)
                        .font(.pretendard(.semiBold, size: 14))
                        .frame(height: 8)
                }
            )
            
            QPTextField(
                textString: .constant("테스트 텍스트"),
                isTextFieldFocused: FocusState<Bool>().projectedValue,
                title: "이메일",
                placeholder: "텍스트를 입력해주세요",
                helperText: "* 아카데미 계정 아이디를 입력해주세요",
                state: .inValid,
                topTrailingView: {
                    Text(Constant.academyEmail)
                        .foregroundStyle(TextLabel.ph)
                        .font(.pretendard(.semiBold, size: 14))
                        .frame(height: 8)
                }
            )
        }
        .padding(.horizontal, 24)
    }
}
