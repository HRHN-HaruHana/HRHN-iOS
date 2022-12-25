//
//  FullWidthButton.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/25.
//

import SwiftUI

// MARK: UIViewRepresentable

struct FullWidthButtonRepresentable: UIViewRepresentable {
    private let title: String
    private let isOnKeyboard: Bool
    private let action: () -> Void
    
        init(
            title: String,
            isOnKeyboard: Bool = false,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.isOnKeyboard = isOnKeyboard
            self.action = action
        }
    
    func makeUIView(context: Context) -> UIFullWidthButton {
        let uiView: UIFullWidthButton = {
            $0.title = title
            $0.withKeyboard = isOnKeyboard
            $0.action = UIAction { _ in
                action()
            }
            return $0
        }(UIFullWidthButton())
        return uiView
    }
    
    func updateUIView(_ uiView: UIFullWidthButton, context: Context) {
        uiView.withKeyboard = isOnKeyboard
    }
}

// MARK: View

struct FullWidthButton: View {
    private let title: String
    private let action: () -> Void
    private var isOnKeyboard = false
    
    init(
        _ title: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        FullWidthButtonRepresentable(
            title: title,
            isOnKeyboard: isOnKeyboard,
            action: action
        )
        .frame(height: 50)
    }
    
    func withKeyboard() -> Self {
        var copy = self
        copy.isOnKeyboard = true
        return copy
    }
}

// MARK: - Preview

#if DEBUG
import SwiftUI

struct FullWidthButtonPreviewView: View {
    @State private var isFullWidthButtonDisabled = true
    
    var body: some View {
        VStack(spacing: 20) {
            FullWidthButton("기본") { }
                .padding(.horizontal, 20)
            FullWidthButton("비활성화") { }
                .disabled(isFullWidthButtonDisabled)
                .padding(.horizontal, 20)
            FullWidthButton("키보드") { }
                .withKeyboard()
            FullWidthButton("키보드 + 비활성화") { }
                .withKeyboard()
                .disabled(isFullWidthButtonDisabled)
            Button("비활성화 토글") {
                isFullWidthButtonDisabled.toggle()
            }
        }
    }
}

struct FullWidthButtonPreviews: PreviewProvider {
    static var previews: some View {
        FullWidthButtonPreviewView()
    }
}
#endif
