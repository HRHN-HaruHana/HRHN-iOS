//
//  FullWidthButton.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/25.
//

import SwiftUI

// MARK: UIViewRepresentable

struct FullWidthButtonRepresentable: UIViewRepresentable {
    @Binding var isDisabled: Bool
    private let title: String
    private let isOnKeyboard: Bool
    private let action: () -> Void
    
        init(
            title: String,
            isDisabled: Binding<Bool> = .constant(false),
            isOnKeyboard: Bool = false,
            action: @escaping () -> Void
        ) {
            self.title = title
            self._isDisabled = isDisabled
            self.isOnKeyboard = isOnKeyboard
            self.action = action
        }
    
    func makeUIView(context: Context) -> UIFullWidthButton {
        let uiView: UIFullWidthButton = {
            $0.title = title
            $0.isDisabled = isDisabled
            $0.withKeyboard = isOnKeyboard
            $0.action = UIAction { _ in
                action()
            }
            return $0
        }(UIFullWidthButton())
        return uiView
    }
    
    func updateUIView(_ uiView: UIFullWidthButton, context: Context) {
        uiView.isDisabled = isDisabled
        uiView.withKeyboard = isOnKeyboard
    }
}

// MARK: View

struct FullWidthButton: View {
    @Binding var isDisabled: Bool
    private let title: String
    private let action: () -> Void
    private var isOnKeyboard = false
    
    init(
        title: String,
        isDisabled: Binding<Bool> = .constant(false),
        action: @escaping () -> Void
    ) {
        self.title = title
        self._isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        FullWidthButtonRepresentable(
            title: title,
            isDisabled: $isDisabled,
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
    
    func disable(_ isDisabled: Binding<Bool>) -> Self {
        var copy = self
        copy._isDisabled = isDisabled
        return copy
    }
}

// MARK: - Preview

#if DEBUG
import SwiftUI

struct previewView: View {
    @State private var isFullWidthButtonDisabled = true
    
    var body: some View {
        VStack(spacing: 20) {
            FullWidthButton(title: "기본") { }
            FullWidthButton(title: "비활성화") { }
                .disable($isFullWidthButtonDisabled)
            FullWidthButton(title: "키보드") { }
                .withKeyboard()
            FullWidthButton(title: "키보드 + 비활성화") { }
                .withKeyboard()
                .disable($isFullWidthButtonDisabled)
            Button("비활성화 토글") {
                isFullWidthButtonDisabled.toggle()
            }
        }
    }
}

struct FullWidthButtonPreviews: PreviewProvider {
    static var previews: some View {
        previewView()
    }
}
#endif
