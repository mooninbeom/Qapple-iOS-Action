//
//  MemberKey.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

extension QappleRepository {
    
    /// 회원가입 인증 메일 발송
    static func makeCertification() -> (_ signUpToken: String, _ email: String) async throws -> Bool {
        return { signUpToken, email in
            let url = try QappleAPI.Member.certification(signUpToken: signUpToken, email: email).url()
            let response: BaseResponse<Bool> = try await NetworkService.shared.get(url: url)
            return response.result
        }
    }
    
    /// 회원가입 인증코드 인증
    static func makeCertificationCodeCheck() -> (_ signUpToken: String, _ email: String, _ certCode: String) async throws -> Bool {
        return { signUpToken, email, certCode in
            let url = try QappleAPI.Member.certificationCodeCheck(signUpToken: signUpToken, email: email, certCode: certCode).url()
            let response: BaseResponse<Bool> = try await NetworkService.shared.get(url: url)
            return response.result
        }
    }
    
    /// 마이페이지 프로필 조회
    static func makeFetchMyPage() -> () async throws -> MyProfile {
        return {
            let url = try QappleAPI.Member.myPage.url()
            let response: BaseResponse<MyPageDTO> = try await NetworkService.shared.get(url: url)
            return response.result.toEntity
        }
    }
    
    /// 마이페이지 프로필 수정
    static func makeEditMyPage() -> (_ nickname: String, _ profileImage: String?) async throws -> EditProfileDTO {
        return { nickname, profileImage in
            let url = try QappleAPI.Member.myPageEdit.url()
            let requestBody: EditProfileRequest = EditProfileRequest(nickname: nickname, profileImage: profileImage)
            let response: BaseResponse<EditProfileDTO> = try await NetworkService.shared.post(url: url, body: requestBody)
            return response.result
        }
    }
    
    /// 닉네임 중복 체크
    static func makeNicknameCheck() -> (_ nickname: String) async throws -> Bool {
        return { nickname in
            let url = try QappleAPI.Member.nicknameCheck(nickname: nickname).url()
            let response: BaseResponse<Bool> = try await NetworkService.shared.get(url: url)
            return response.result
        }
    }
    
    /// 회원탈퇴
    static func makeResign() -> () async throws -> Bool {
        return {
            let url = try QappleAPI.Member.resign.url()
            let response: BaseResponse<Bool> = try await NetworkService.shared.get(url: url)
            return response.result
        }
    }
    
    /// 로그인
    static func makeSignIn() -> (_ code: String, _ diviceToken: String) async throws -> SignInDTO {
        return { code, diviceToken in
            let url = try QappleAPI.Member.signIn(code: code, deviceToken: diviceToken).url()
            let response: BaseResponse<SignInDTO> = try await NetworkService.shared.get(url: url)
            return response.result
        }
    }
    
    /// 회원가입
    static func makeSignUp() -> (_ signUpToken: String, _ email: String, _ nickname: String, _ profileImage: String?, _ deviceToken: String) async throws -> SignUpDTO {
        return { signUpToken, email, nickname, profileImage, deviceToken in
            let url = try QappleAPI.Member.signUp.url()
            let requestBody: SignUpRequest = SignUpRequest(signUpToken: signUpToken, email: email, nickname: nickname, profileImage: profileImage, deviceToken: deviceToken)
            let response: BaseResponse<SignUpDTO> = try await NetworkService.shared.post(url: url, body: requestBody)
            return response.result
        }
    }
}
