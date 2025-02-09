//
//  NotificationRepository.swift
//  Qapple
//
//  Created by 문인범 on 1/27/25.
//

import Foundation
import ComposableArchitecture


/**
 캐플 앱 푸쉬 알림(Push Notification) 의존성
 */
struct NotificationRepository {
    var fetchNotificationList: (_ threshold: Int?) async throws -> ([QappleNotification], QappleAPI.PaginationInfo)
    var fetchSingleBoard: (_ boardId: Int) async throws -> BulletinBoard
    var isAnsweredQuestion: (_ questionId: Int) async throws -> (Bool, Question)
    
    private static let dummyNoti: [QappleNotification] = {
        var result = [QappleNotification]()
        for i in 0 ..< 25 {
            result.append(.init(
                id: String(i),
                boardId: String(i),
                boardCommentId: nil,
                title: "테스트입니다 \(i)",
                subtitle: nil,
                content: "테스트 컨텐츠 입니다 \(i)",
                createAt: Date(timeIntervalSinceNow: Double(-60*60*60*i)),
                isReadStatus: false
            ))
        }
        return result
    }()
    
    private static let dummyBoard = BulletinBoard(
        id: 1,
        writerId: 1,
        writerNickname: "이호창",
        content: "특전사",
        heartCount: 10,
        commentCount: 13,
        createAt: .init(),
        isMine: false,
        isReported: false,
        isLiked: true
    )
}


extension NotificationRepository: DependencyKey {
    static let liveValue: NotificationRepository = Self(
        fetchNotificationList: { threshold in
            let url = try QappleAPI.Notification.list(threshold: threshold, pageSize: 25).url()
            let response: BaseResponse<NotificationsDTO> = try await NetworkService.shared.get(url: url)
            return response.result.toEntityWithThreshold
        },
        fetchSingleBoard: { boardId in
            let url = try QappleAPI.Board.single(boardId: boardId).url()
            let response: BaseResponse<BulletinBoardDTO.Content> = try await NetworkService.shared.get(url: url)
            return response.result.toEntity
        },
        isAnsweredQuestion: { questionId in
            var hasNext = true
            var threshold: String?
            
            while hasNext {
                let url = try QappleAPI.Question.list(threshold: threshold, pageSize: 30).url()
                let response: BaseResponse<QuestionsDTO> = try await NetworkService.shared.get(url: url)
                
                if let question = response.result.content.first(where: { $0.questionId == questionId }) {
                    let entity = Question(
                        id: question.questionId,
                        content: question.content,
                        publishedDate: question.livedAt?.ISO8601ToDate ?? .init(),
                        isAnswered: question.isAnswered,
                        isLived: question.questionStatus == "LIVE"
                    )
                    
                    return (question.isAnswered, entity)
                }
                
                hasNext = response.result.hasNext
                threshold = response.result.threshold
            }
            
            // id에 맞는 질문 찾기 실패시 에러 던지기
            throw NSError()
        }
    )
    
    static let previewValue: NotificationRepository = Self(
        fetchNotificationList: { _ in
            (NotificationRepository.dummyNoti, .init(threshold: "", hasNext: true))
        },
        fetchSingleBoard: { _ in
            NotificationRepository.dummyBoard
        },
        isAnsweredQuestion: { _ in
            let question = Question(
                id: 1234,
                content: "테스트 질문 입니다.",
                publishedDate: .init(),
                isAnswered: false,
                isLived: true
            )
            
            return (false, question)
        }
    )
}


extension DependencyValues {
    var notificationRepository: NotificationRepository {
        get { self[NotificationRepository.self] }
        set { self[NotificationRepository.self] = newValue }
    }
}
