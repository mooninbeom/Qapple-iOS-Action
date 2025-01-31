//
//  MemberRepository.swift
//  Qapple
//
//  Created by Simmons on 1/31/25.
//

import Foundation
import ComposableArchitecture

struct MemberRepository {
    var certification: (_ signUpToken: String, _ email: String) async throws -> Bool
    var certificationCodeCheck: (_ signUpToken: String, _ email: String, _ certCode: String) async throws -> Bool
    var fetchMyPage: () async throws -> MyProfile
    var editMyPage: (_ nickname: String, _ profileImage: String?) async throws -> Void
    var nicknameCheck: (_ nickname: String) async throws -> Bool
    var resign: () async throws -> Bool
    var signIn: (_ code: String, _ diviceToken: String) async throws -> Void
    var signUp: (_ signUpToken: String, _ email: String, _ nickname: String, _ profileImage: String?, _ deviceToken: String) async throws -> SignUpDTO
}

extension MemberRepository: DependencyKey {
    
    static let liveValue = Self(
        certification: { signUpToken, email in
            let url = try QappleAPI.Member.certification(signUpToken: signUpToken, email: email).url()
            let response: BaseResponse<Bool> = try await NetworkService.shared.get(url: url)
            return response.result
        },
        certificationCodeCheck: { signUpToken, email, certCode in
            let url = try QappleAPI.Member.certificationCodeCheck(signUpToken: signUpToken, email: email, certCode: certCode).url()
            let response: BaseResponse<Bool> = try await NetworkService.shared.get(url: url)
            return response.result
        },
        fetchMyPage: {
            let url = try QappleAPI.Member.myPage.url()
            let response: BaseResponse<MyPageDTO> = try await NetworkService.shared.get(url: url)
            return response.result.toEntity
        },
        editMyPage: { nickname, profileImage in
            let url = try QappleAPI.Member.myPageEdit.url()
            let requestBody: EditProfileRequest = EditProfileRequest(nickname: nickname, profileImage: profileImage)
            let response: BaseResponse<EditProfileDTO> = try await NetworkService.shared.post(url: url, body: requestBody)
        },
        nicknameCheck: { nickname in
            let url = try QappleAPI.Member.nicknameCheck(nickname: nickname).url()
            let response: BaseResponse<Bool> = try await NetworkService.shared.get(url: url)
            return response.result
        },
        resign: {
            let url = try QappleAPI.Member.resign.url()
            let response: BaseResponse<Bool> = try await NetworkService.shared.get(url: url)
            return response.result
        },
        signIn: { code, diviceToken in
            let url = try QappleAPI.Member.signIn(code: code, deviceToken: diviceToken).url()
            let response: BaseResponse<SignInDTO> = try await NetworkService.shared.get(url: url)
        },
        signUp: { signUpToken, email, nickname, profileImage, deviceToken in
            let url = try QappleAPI.Member.signUp.url()
            let requestBody: SignUpRequest = SignUpRequest(signUpToken: signUpToken, email: email, nickname: nickname, profileImage: profileImage, deviceToken: deviceToken)
            let response: BaseResponse<SignUpDTO> = try await NetworkService.shared.post(url: url, body: requestBody)
            return response.result
        }
    )
    
    static let previewValue = Self(
        certification: { signUpToken, email in
            print("인증 요청: token=\(signUpToken), email=\(email)")
            return true
        },
        certificationCodeCheck: { signUpToken, email, certCode in
            print("인증 코드 확인: token=\(signUpToken), email=\(email), code=\(certCode)")
            return certCode == "123456"
        },
        fetchMyPage: {
            MyProfile(nickname: "프리뷰 유저", profileImage: nil, joinDate: "2025-01-31")
        },
        editMyPage: { nickname, profileImage in
            print("프로필 수정: nickname=\(nickname), profileImage=\(profileImage ?? "없음")")
        },
        nicknameCheck: { nickname in
            print("닉네임 중복 확인: \(nickname)")
            return nickname != "이미사용중"
        },
        resign: {
            print("회원 탈퇴 요청")
            return true
        },
        signIn: { code, deviceToken in
            print("로그인 요청: code=\(code), deviceToken=\(deviceToken)")
        },
        signUp: { signUpToken, email, nickname, profileImage, deviceToken in
            print("회원가입 요청: token=\(signUpToken), email=\(email), nickname=\(nickname)")
            return SignUpDTO(accessToken: "dummy_access_token", refreshToken: "dummy_refresh_token")
        }
    )
}

extension DependencyValues {
    var memberRepository: MemberRepository {
        get { self[MemberRepository.self] }
        set { self[MemberRepository.self] = newValue }
    }
}
