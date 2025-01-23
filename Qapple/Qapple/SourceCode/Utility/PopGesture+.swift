//
//  PopGesture+.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/25/24.
//

import UIKit
import SwiftUI

// MARK: - PopGestureManager 싱글톤

final class PopGestureManager {
    static let shared = PopGestureManager()
    private init() {}
    
    /// Pop 제스처를 허용하는지 확인 변수
    private var isAllowPopGestureValue = true
    
    /// Pop 제스처 받아오기
    func isAllowPopGesture() -> Bool {
        return isAllowPopGestureValue
    }
    
    /// Pop 제스처를 허용하는 변수 업데이트
    @MainActor
    func updateAllowPopGesture(_ bool: Bool) async {
        isAllowPopGestureValue = bool
    }
}

// MARK: - ViewModifier

struct PopGestureDisabledViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .task {
                await PopGestureManager.shared.updateAllowPopGesture(false)
            }
            .onDisappear {
                Task {
                    await PopGestureManager.shared.updateAllowPopGesture(true)
                }
            }
    }
}

extension View {
    
    func popGestureDisabled() -> some View {
        modifier(PopGestureDisabledViewModifier())
    }
}

// MARK: - UINavigationController 확장

extension UINavigationController: @retroactive ObservableObject, @retroactive UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return PopGestureManager.shared.isAllowPopGesture() && viewControllers.count > 1
    }
}
