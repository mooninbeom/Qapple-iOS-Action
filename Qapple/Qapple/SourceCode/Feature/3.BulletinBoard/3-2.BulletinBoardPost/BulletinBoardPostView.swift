//
//  BulletinBoardPostView.swift
//  Qapple
//
//  Created by Simmons on 1/28/25.
//

import SwiftUI
import ComposableArchitecture

struct BulletinBoardPostView: View {
    
    @Bindable var store: StoreOf<BulletinBoardPostFeature>
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                BulletinBoardPostNavigationBar(store: store)
                Spacer()
                BoardTextField(store: store, isTextFieldFocused: $isTextFieldFocused)
                Spacer()
                Footer(store: store)
            }
        }
        .background(.first)
        .navigationBarBackButtonHidden()
        .popGestureDisabled()
        .onTapGesture {
            isTextFieldFocused.toggle()
        }
        .loadingIndicator(isLoading: store.isLoading)
        .disabled(store.isLoading)
        .alert($store.scope(state: \.alert, action: \.alert))
        .sheet(item: $store.scope(state: \.sheet?.anonymityNotice, action: \.sheet.anonymityNotice)
        ) { _ in
            AnonymityNoticeSheet()
        }
    }
}

// MARK: - NavigationBar

private struct BulletinBoardPostNavigationBar: View {
    
    let store: StoreOf<BulletinBoardPostFeature>

    var body: some View {
        NavigationBar(
            title: "게시글 작성",
            leadingView: {
                NavigationButton(buttonType: .text("취소", .icon)) {
                    store.send(.cancelButtonTapped)
                }
            },
            trailingView: {
                NavigationButton(buttonType: .text("완료", store.boardText.isEmpty ? .disable : .button)) {
                    if !store.boardText.isEmpty {
                        HapticService.notification(type: .success)
                        store.send(.postBoardButtonTapped)
                    }
                }
                .disabled(store.boardText.isEmpty)
            }
        )
    }
}

// MARK: - WritingView

private struct BoardTextField: View {
    
    @Bindable var store: StoreOf<BulletinBoardPostFeature>
    @FocusState.Binding var isTextFieldFocused: Bool

    var body: some View {
        ZStack {
            if store.boardText.isEmpty {
                Placeholder()
            }

            TextField(text: $store.boardText, axis: .vertical) {}
                .font(.pretendard(.semiBold, size: store.boardTextFontSize))
                .foregroundStyle(.wh)
                .focused($isTextFieldFocused)
                .padding(.horizontal, 24)
                .autocorrectionDisabled()
                .multilineTextAlignment(.center)
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
}

// MARK: - Footer

private struct Footer: View {
    
    let store: StoreOf<BulletinBoardPostFeature>
    
    var body: some View {
        HStack {
            Button {
                store.send(.anonymityNoticeButtonTapped)
            } label: {
                Text("익명이 보장되나요?")
                    .font(.pretendard(.semiBold, size: 12))
                    .foregroundStyle(BrandPink.text)
            }
            
            Spacer()

            Text("\(store.boardText.count)/\(store.textCountLimit)")
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(TextLabel.sub3)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 12)
    }
}

// MARK: - Preview

#Preview {
    BulletinBoardPostView(store: Store(initialState: BulletinBoardPostFeature.State()){
        BulletinBoardPostFeature()
    })
}
