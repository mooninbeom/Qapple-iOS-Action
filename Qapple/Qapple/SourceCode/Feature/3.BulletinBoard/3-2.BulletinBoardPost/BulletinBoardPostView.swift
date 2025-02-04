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
                WritingView(store: store, isTextFieldFocused: $isTextFieldFocused)
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
                NavigationButton(buttonType: .text("완료", store.content.isEmpty ? .disable : .button)) {
                    if !store.content.isEmpty {
                        HapticService.notification(type: .success)
                        store.send(.postBoardButtonTapped)
                    }
                }
                .disabled(store.content.isEmpty)
            }
        )
    }
}

// MARK: - WritingView

private struct WritingView: View {
    
    @Bindable var store: StoreOf<BulletinBoardPostFeature>

    var isTextFieldFocused: FocusState<Bool>.Binding

    var body: some View {
        ZStack {
            if store.content.isEmpty {
                Placeholder()
            }

            PostTextField(store: store, isTextFieldFocused: isTextFieldFocused)
        }
        .multilineTextAlignment(.center)
    }
}

// MARK: - Placeholder

private struct Placeholder: View {

    var body: some View {
        VStack(spacing: 16) {
            Text("자유롭게 생각을\n작성해주세요")
                .font(.pretendard(.semiBold, size: 48))

            Text("* 논란을 만들 질문들은 지양해주세요")
                .font(.pretendard(.medium, size: 16))
                .lineSpacing(6)
        }
        .foregroundStyle(TextLabel.ph)
        .padding(.horizontal, 24)
    }
}

// MARK: - PostTextField

private struct PostTextField: View {
    
    @Bindable var store: StoreOf<BulletinBoardPostFeature>
    
    @State var fontSize: CGFloat = 48

    var isTextFieldFocused: FocusState<Bool>.Binding

    var body: some View {
        TextField(text: $store.content, axis: .vertical) {}
            .font(.pretendard(.semiBold, size: store.fontSize))
            .foregroundStyle(.wh)
            .focused(isTextFieldFocused)
            .padding(.horizontal, 24)
            .autocorrectionDisabled()
    }
}

// MARK: - Footer

private struct Footer: View {
    
    @Bindable var store: StoreOf<BulletinBoardPostFeature>
    
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

            Text("\(store.content.count)/\(store.textCountLimit)")
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
