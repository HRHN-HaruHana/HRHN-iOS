//
//  ReviewView.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/26.
//

import SwiftUI

struct ReviewView: View {
    @State private var selectedEmoji: Emoji = .none
    @State private var lastChallenge: Challenge = Challenge.mock[0]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("오늘을 시작하기 전,\n저번 챌린지를 평가하세요")
                .font(.system(size: 25, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer(minLength: 20)
            Text(lastChallenge.content)
                .foregroundColor(.challengeCardLabel)
                .padding(20.adjusted)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 100.adjusted)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.challengeCardFill)
                }
                .padding(.horizontal, 15)
            Spacer(minLength: 20)
            Grid(horizontalSpacing: 10.adjusted, verticalSpacing: 10.adjusted) {
                GridRow {
                    emojiButton(.red)
                    emojiButton(.yellow)
                    emojiButton(.green)
                }
                GridRow {
                    emojiButton(.skyblue)
                    emojiButton(.blue)
                    emojiButton(.purple)
                }
            }
            .padding(.horizontal, 15)
            Spacer(minLength: 20)
            FullWidthButton("다음") {
                // TODO: Push
            }
            .disabled(selectedEmoji == .none)
        }
        .padding(20)
        .setBackgroundColor(.background)
    }
}

// MARK: ViewBuilder

private extension ReviewView {
    
    @ViewBuilder
    func emojiImage(_ emoji: Emoji) -> some View {
        Image(emoji.rawValue)
            .resizable()
            .frame(width: 100.adjusted, height: 100.adjusted)
    }
    
    @ViewBuilder
    func emojiButton(_ emoji: Emoji) -> some View {
        Button {
            selectedEmoji = emoji
        } label: {
            if selectedEmoji == emoji {
                emojiImage(emoji)
                    .overlay {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.black)
                                .opacity(0.3)
                                .mask(emojiImage(emoji))
                            Image(systemName: "checkmark")
                                .font(.system(size: 30, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    
            } else {
                emojiImage(emoji)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView()
    }
}
#endif
