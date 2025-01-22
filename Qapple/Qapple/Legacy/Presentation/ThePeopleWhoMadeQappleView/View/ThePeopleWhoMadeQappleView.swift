//
//  ThePeopleWhoMadeQappleView.swift
//  Qapple
//
//  Created by kyungsoolee on 12/27/24.
//

import SwiftUI

struct ThePeopleWhoMadeQappleView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CustomTabBar()
                ScrollView {

                    
                    CustomBookMark(position: "Product Manager")
                    ProfileCell(avatar: .friday, backgroundColor: .friday, nicknameKor: "프라이데이", nicknameEng: "friday", position: "Product Manager", description: "대전 사람입니다. 성심당 잘 안먹습니다.", githubLink: nil, linkedinLink: "https://www.linkedin.com/in/minwoo-kim-7b94952b7/")
                    ProfileCell(avatar: .sammy, backgroundColor: .sammy, nicknameKor: "세미", nicknameEng: "sammy", position: "Product Manager", description: "냉정과 열정 사이", githubLink: nil, linkedinLink: "www.linkedin.com/in/sammy-kwak-8b2286221")
                    
                    CustomBookMark(position: "Designer")
                    ProfileCell(avatar: .lamune, backgroundColor: .lamune, nicknameKor: "라무네", nicknameEng: "lamune", position: "Designer", description: "인풋과 아웃풋의 조화", githubLink: nil, linkedinLink: "https://www.linkedin.com/in/minwoo-kim-7b94952b7/")
                    
                    CustomBookMark(position: "iOS Developer")
                    
                    ProfileCell(avatar: .hantol, backgroundColor: .hantol, nicknameKor: "한톨", nicknameEng: "hantol", position: "iOS Developer", description: "디자이너와 개발자, 그 사이 어딘가", githubLink: "https://github.com/thinkySide", linkedinLink: nil)
                    ProfileCell(avatar: .mooni, backgroundColor: .mooni, nicknameKor: "무니", nicknameEng: "monni", position: "iOS Developer", description: "월드 클래스 디벨로퍼", githubLink: nil, linkedinLink: "www.linkedin.com/in/인범-문-94ba63298")
                    ProfileCell(avatar: .simons, backgroundColor: .simons, nicknameKor: "시몬스", nicknameEng: "simons", position: "iOS Developer", description: "흔들리지 않는 편안함", githubLink: nil, linkedinLink: "https://www.linkedin.com/in/omj0722/")

                    

                    
                    CustomBookMark(position: "Back-end Developer")
                    ProfileCell(avatar: .liver, backgroundColor: .liver, nicknameKor: "리버", nicknameEng: "liver", position: "Back-end Developer", description: "노는게 제일 좋아! 하나!", githubLink: "https://github.com/kyxxgsoo", linkedinLink: nil)
                    ProfileCell(avatar: .mango, backgroundColor: .mango, nicknameKor: "망고", nicknameEng: "mango", position: "Back-end Developer", description: "노는게 제일 좋아! 둘!", githubLink: nil, linkedinLink: "https://www.linkedin.com/in/재원-이-859981227/")

                    ProfileCell(avatar: .lucy, backgroundColor: .lucy, nicknameKor: "루시", nicknameEng: "lucy", position: "Back-end Developer", description: "노는게 제일 좋아! 셋!", githubLink: "https://github.com/tnals2384", linkedinLink: nil)

                    ProfileCell(avatar: .ari, backgroundColor: .ari, nicknameKor: "아리", nicknameEng: "ari", position: "Back-end Developer", description: "노는게 제일 좋아! 야!", githubLink: "https://github.com/youngeun-dev", linkedinLink: nil)

                    Spacer()
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
        }
        .background(Background.first)
    }
}

// MARK: - 커스텀 탭바
private struct CustomTabBar: View {
    
    @EnvironmentObject var pathModel: Router
    
    var body: some View {
        CustomNavigationBar(
            leadingView: {
                HStack(spacing: 12) {
                    
                    Button {
                        // TODO: 어디로 이동할지 pathModel 추가
                        
                    } label: {
                        Image(.customBackButtonIcon)
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(GrayScale.icon)
                            .frame(width: 26 , height: 26)
                    }
                }
                .padding(.trailing, 8)
            },
            principalView: {
                Text("케플을 만든 사람들")
                    .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main)
            },
            trailingView: {
            },
            backgroundColor: Background.first)
    }
}

private struct CustomBookMark: View {
    let position: String
    var body: some View {
        HStack {
            Text(position)
                .font(Font.pretendard(.semiBold, size: 16))
                .foregroundStyle(.sub2)
            Spacer()
        }
    }
    
}

#Preview {
    ThePeopleWhoMadeQappleView()
}
