//
//  WriteAnswerFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/24/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct WriteAnswerFeature {
    
    @ObservableState
    struct State: Equatable {
        @Presents var sheet: Sheet.State?
        var question: Question
        let textLimit = 250
        var answerText: String = ""
        var answerTextFontSize: CGFloat = 48
    }
    
    enum Action {
        case typeAnswerText(String)
        case anonymityNoticeButtonTapped
        case dismissButtonTapped
        case completeButtonTapped
        case sheet(PresentationAction<Sheet.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .typeAnswerText(text):
                if text.count <= state.textLimit {
                    state.answerText = text
                    state.answerTextFontSize = adaptiveFontSize(from: text)
                }
                return .none
                
            case .anonymityNoticeButtonTapped:
                state.sheet = .anonymityNotice
                return .none
                
            case .dismissButtonTapped:
                return .none
                
            case .completeButtonTapped:
                return .none
                
            case .sheet:
                return .none
            }
        }
        .ifLet(\.$sheet, action: \.sheet)
    }
}

// MARK: - Destination

extension WriteAnswerFeature {
    
    @Reducer(state: .equatable)
    enum Sheet {
        case anonymityNotice
    }
}

// MARK: - Helper

extension WriteAnswerFeature {
    
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
