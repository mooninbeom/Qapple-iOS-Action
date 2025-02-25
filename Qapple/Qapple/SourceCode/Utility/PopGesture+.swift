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
    func updateAllowPopGesture(_ bool: Bool) {
        isAllowPopGestureValue = bool
    }
}

// MARK: - ViewModifier

struct PopGestureViewModifier: ViewModifier {
    
    let isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .task {
                PopGestureManager.shared.updateAllowPopGesture(isActive)
            }
    }
}

extension View {
    
    func popGestureEnabled(_ isActive: Bool) -> some View {
        modifier(PopGestureViewModifier(isActive: isActive))
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
