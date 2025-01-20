//
//  HideKeyboard+.swift
//  Qapple
//
//  Created by 김민준 on 1/20/25.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
