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
        var question: Question
        let textLimit = 250
        var answerText: String = ""
        var answerTextFontSize: CGFloat = 48
        @Presents var sheet: Sheet.State?
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case typeAnswerText(String)
        case anonymityNoticeButtonTapped
        case dismissButtonTapped
        case completeButtonTapped
        case postAnswerResponse(Question)
        case sheet(PresentationAction<Sheet.Action>)
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {
            case stopAnswering
        }
    }
    
    @Dependency(\.answerRepository.postAnswer) var postAnswer
    @Dependency(\.dismiss) var dismiss
    
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
                if state.answerText.isEmpty {
                    return .run { send in
                        await dismiss()
                    }
                } else {
                    state.alert = .stopAnswering
                    return .none
                }
                
            case .completeButtonTapped:
                guard !state.answerText.isEmpty else { return .none }
                return .run { [state = state] send in
                    do {
                        try await postAnswer(state.question.id, state.answerText)
                        await send(.postAnswerResponse(state.question))
                    } catch {
                        print(error)
                    }
                }
                
            case .alert(.presented(.stopAnswering)):
                return .run { send in
                    await dismiss()
                }
                
            case .postAnswerResponse:
                return .none
                
            case .sheet, .alert:
                return .none
            }
        }
        .ifLet(\.$sheet, action: \.sheet)
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - Sheet

extension WriteAnswerFeature {
    
    @Reducer(state: .equatable)
    enum Sheet {
        case anonymityNotice
    }
}

// MARK: - Alert

extension AlertState where Action == WriteAnswerFeature.Action.Alert {
    static let stopAnswering = AlertState {
        TextState("정말 그만두시겠어요?")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("취소")
        }
        ButtonState(role: .destructive, action: .stopAnswering) {
            TextState("그만두기")
        }
    } message: {
        TextState("지금까지 작성한 답변이 사라져요")
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
