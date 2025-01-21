//
//  ReportsKey.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

extension QappleRepository {
    
    /// 게시판 신고
    static func makeReportsBoard() -> (_ boardId: Int, _ boardReportType: String) async throws -> BoardReportsDTO {
        return { boardId, boardReportType in
            let url = try QappleAPI.Reports.board(boardId: boardId, boardReportType: boardReportType).url()
            let requestBody: BoardReportsRequest = BoardReportsRequest(boardId: boardId, boardReportType: boardReportType)
            let response: BaseResponse<BoardReportsDTO> = try await networkClient.post(url: url, body: requestBody)
            return response.result
        }
    }
    
    /// 게시판 댓글 신고
    static func makeReportsBoardComment() -> (_ boardCommentId: Int, _ boardCommentReportType: String) async throws -> BoardCommentReportsDTO {
        return { boardCommentId, boardCommentReportType in
            let url = try QappleAPI.Reports.boardComment(boardCommentId: boardCommentId, boardCommentReportType: boardCommentReportType).url()
            let requestBody: BoardCommentReportsRequest = BoardCommentReportsRequest(boardCommentId: boardCommentId , boardCommentReportType: boardCommentReportType)
            let response: BaseResponse<BoardCommentReportsDTO> = try await networkClient.post(url: url, body: requestBody)
            return response.result
        }
    }
    
    /// 답변 신고
    static func makeReportsAnswer() -> (_ answerId: Int, _ reportType: String) async throws -> AnswerReportsDTO {
        return { answerId, reportType in
            let url = try QappleAPI.Reports.answer(answerId: answerId, reportType: reportType).url()
            let requestBody: AnswerReportsRequest = AnswerReportsRequest(answerId: answerId, reportType: reportType)
            let response: BaseResponse<AnswerReportsDTO> = try await networkClient.post(url: url, body: requestBody)
            return response.result
        }
    }
}
