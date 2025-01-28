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

    @EnvironmentObject private var pathModel: Router
    
    @StateObject private var postingUseCase = BulletinPostingUseCase()

    @State private var isBackAlertPresented = false

    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                NavigationBar(store: store, isBackAlertPresented: $isBackAlertPresented)
                Spacer()
                WritingView(store: store, isTextFieldFocused: $isTextFieldFocused)
                Spacer()
                Footer(store: store)
            }
            if store.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.primary)
            }
        }
        .background(Background.first)
        .navigationBarBackButtonHidden()
        .environmentObject(postingUseCase)
        .popGestureDisabled()
        .onTapGesture {
            isTextFieldFocused.toggle()
        }
        .disabled(store.isLoading)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

// MARK: - NavigationBar

private struct NavigationBar: View {
    
    @Bindable var store: StoreOf<BulletinBoardPostFeature>

    @EnvironmentObject private var pathModel: Router
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    @EnvironmentObject private var postingUseCase: BulletinPostingUseCase

    @Binding private(set) var isBackAlertPresented: Bool

    var body: some View {
        CustomNavigationBar(
            leadingView: {
                Button("취소") {
                    store.send(.cancelButtonTapped)
                }
                .foregroundStyle(GrayScale.icon)
            },
            principalView: {
                Text("게시판")
                    .pretendard(.semiBold, 17)
                    .foregroundStyle(TextLabel.main)
            },
            trailingView: {
                Button("올리기") {
                    if store.content != "" {
                        Task {
                            HapticService.notification(type: .success)
                            try await postingUseCase.effect(.uploadPost)
                            bulletinBoardUseCase.reset()
                            pathModel.pop()
                            postingUseCase.isLoading = false
                        }
                    }
                }
                .foregroundStyle(store.content.isEmpty ? .disable : BrandPink.button)
                .disabled(store.content.isEmpty)
            },
            backgroundColor: .clear
        )
    }
}

// MARK: - WritingView

private struct WritingView: View {
    
    @Bindable var store: StoreOf<BulletinBoardPostFeature>

    @EnvironmentObject private var postingUseCase: BulletinPostingUseCase

    var isTextFieldFocused: FocusState<Bool>.Binding

    var body: some View {
        ZStack {
            if store.content == "" {
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
        .foregroundStyle(TextLabel.placeholder)
        .padding(.horizontal, 24)
    }
}

// MARK: - PostTextField

private struct PostTextField: View {
    
    @Bindable var store: StoreOf<BulletinBoardPostFeature>
    @State var fontSize: CGFloat = 48

    var isTextFieldFocused: FocusState<Bool>.Binding

    var body: some View {
        TextField(
            text: $store.content.sending(\.setContent),
            axis: .vertical
        ) {
            Color.clear
        }
        .font(.pretendard(.semiBold, size: fontSize))
        .foregroundStyle(.wh)
        .focused(isTextFieldFocused)
        .padding(.horizontal, 24)
        .autocorrectionDisabled()
        .onChange(of: store.content){ _ in
            fontSize = store.fontSize}
    }
}

// MARK: - Footer

private struct Footer: View {
    
    @Bindable var store: StoreOf<BulletinBoardPostFeature>

    @EnvironmentObject private var postingUseCase: BulletinPostingUseCase

    @State private var isAnonymitySheetPresented = false

    var body: some View {
        HStack {
            Button {
                isAnonymitySheetPresented.toggle()
            } label: {
                Text("익명이 보장되나요?")
                    .font(.pretendard(.semiBold, size: 12))
                    .foregroundStyle(BrandPink.text)
            }
            .sheet(isPresented: $isAnonymitySheetPresented) {
                AnonymityNoticeView(isAnonymitySheetPresented: $isAnonymitySheetPresented)
                    .presentationDetents([.height(560)])
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
    BulletinPostingView()
}
