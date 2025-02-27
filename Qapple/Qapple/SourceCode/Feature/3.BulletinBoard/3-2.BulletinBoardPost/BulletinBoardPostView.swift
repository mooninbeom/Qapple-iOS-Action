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
        .popGestureEnabled(false)
        .onTapGesture {
            isTextFieldFocused.toggle()
        }
        .loadingIndicator(isLoading: store.isLoading)
        .disabled(store.isLoading)
        .alert($store.scope(state: \.alert, action: \.alert))
        .sheet(item: $store.scope(state: \.sheet?.anonymityNotice, action: \.sheet.anonymityNotice)
        ) { _ in
            QPAnonymityNoticeSheet()
        }
    }
}

// MARK: - NavigationBar

private struct BulletinBoardPostNavigationBar: View {
    
    let store: StoreOf<BulletinBoardPostFeature>

    var body: some View {
        QPNavigationBar(
            title: "게시글 작성",
            leadingView: {
                QPNavigationButton(buttonType: .text("취소", .icon)) {
                    store.send(.cancelButtonTapped)
                }
            },
            trailingView: {
                QPNavigationButton(buttonType: .text("완료", store.boardText.isEmpty ? .disable : .button)) {
                    if !store.boardText.isEmpty {
                        store.send(.postBoardButtonTapped)
                    }
                }
                .disabled(store.boardText.isEmpty || store.isLoading)
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
                QPMainContentPlaceholder()
            }

            TextField(text: $store.boardText, axis: .vertical) {}
                .font(.pretendard(.semiBold, size: store.boardTextFontSize))
                .foregroundStyle(.wh)
                .focused($isTextFieldFocused)
                .padding(.horizontal, 24)
                .autocorrectionDisabled()
                .multilineTextAlignment(.center)
                .onChange(of: store.boardText) { _, _ in
                    store.send(.boardTextChanged)
                }
        }
        .onTapGesture {
            isTextFieldFocused = true
        }
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
