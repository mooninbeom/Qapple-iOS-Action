//
//  MemberRepository.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import Foundation

struct MemberRepository {
    var signIn: (_ code: String) async throws -> Bool
    var signUp: (_ email: String, _ nickname: String) async throws -> Void
    var sendCertificationEmail: (_ email: String) async throws -> Bool
    var checkAuthCode: (_ email: String, _ certCode: String) async throws -> Bool
    var checkNicknameDuplicate: (_ nickname: String) async throws -> Bool
    var fetchMyPage: () async throws -> MyProfile
    var editMyPage: (_ nickname: String, _ profileImage: String?) async throws -> Void
    var resign: () async throws -> Bool
}

// MARK: - DependencyKey

extension MemberRepository: DependencyKey {
    
    @Dependency(\.keychainService) static var keychainService
    
    static let liveValue = Self(
        signIn: { code in
            let deviceToken = try keychainService.fetchData(.deviceToken)
            let url = try QappleAPI.Member.signIn(code: code, deviceToken: deviceToken).url()
            let response: BaseResponse<SignInDTO> = try await NetworkService.shared.signIn(url: url)
            try keychainService.createData(.accessToken, response.result.accessToken ?? "")
            try keychainService.createData(.refreshToken, response.result.refreshToken ?? "")
            return response.result.isMember
        },
        signUp: { email, nickname in
            let url = try QappleAPI.Member.signUp.url()
            let refreshToken = try keychainService.fetchData(.refreshToken)
            let deviceToken = try keychainService.fetchData(.deviceToken)
            let requestBody: SignUpRequest = SignUpRequest(signUpToken: refreshToken, email: email, nickname: nickname, deviceToken: deviceToken)
            let response: BaseResponse<SignUpDTO> = try await NetworkService.shared.post(url: url, body: requestBody)
            try keychainService.createData(.accessToken, response.result.accessToken ?? "")
            try keychainService.createData(.refreshToken, response.result.refreshToken ?? "")
            return ()
        },
        sendCertificationEmail: { email in
            let refreshToken = try keychainService.fetchData(.refreshToken)
            let url = try QappleAPI.Member.certification(signUpToken: refreshToken, email: email).url()
            let response: BaseResponse<Bool> = try await NetworkService.shared.get(url: url)
            return response.result
        },
        checkAuthCode: { email, certCode in
            let refreshToken = try keychainService.fetchData(.refreshToken)
            let url = try QappleAPI.Member.certificationCodeCheck(signUpToken: refreshToken, email: email, certCode: certCode).url()
            let response: BaseResponse<Bool> = try await NetworkService.shared.get(url: url)
            return response.result
        },
        checkNicknameDuplicate: { nickname in
            let url = try QappleAPI.Member.nicknameCheck(nickname: nickname).url()
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
        resign: {
            let url = try QappleAPI.Member.resign.url()
            let response: BaseResponse<Bool> = try await NetworkService.shared.get(url: url)
            return response.result
        }
    )
    
    static let previewValue = Self(
        signIn: { code in
            print("로그인 요청: code=\(code)")
            return true
        },
        signUp: { email, nickname in
            print("회원가입 요청: email=\(email), nickname=\(nickname)")
        },
        sendCertificationEmail: { email in
            print("email=\(email)")
            return true
        },
        checkAuthCode: { email, certCode in
            print("인증 코드 확인: email=\(email), code=\(certCode)")
            return certCode == "12345"
        },
        checkNicknameDuplicate: { nickname in
            print("닉네임 중복 확인: \(nickname)")
            return nickname != "이미사용중"
        },
        fetchMyPage: {
            MyProfile(nickname: "프리뷰 유저", profileImage: nil, joinDate: "2025-01-31")
        },
        editMyPage: { nickname, profileImage in
            print("프로필 수정: nickname=\(nickname), profileImage=\(profileImage ?? "없음")")
        },
        resign: {
            print("회원 탈퇴 요청")
            return true
        }
    )
}

// MARK: - DependencyValues

extension DependencyValues {
    var memberRepository: MemberRepository {
        get { self[MemberRepository.self] }
        set { self[MemberRepository.self] = newValue }
    }
}
