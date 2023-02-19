//
//  ReviewView.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/26.
//

import SwiftUI

struct ReviewView: View {
    @ObservedObject private var viewModel: ReviewViewModel
    
    private var titleLabel: String {
        switch viewModel.previousTab {
        case .addTab:
            return I18N.emojiTitleAdd
        case .recordTab:
            return I18N.emojiTitleRecord
        }
    }
    
    init(viewModel: ReviewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(titleLabel)
                .font(.system(size: 25, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer(minLength: 20)
            Text(viewModel.challenge.content)
                .foregroundColor(.cellLabel)
                .padding(20.horizontallyAdjusted)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 100.horizontallyAdjusted)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.cellFill)
                }
                .padding(.horizontal, 15)
            Spacer(minLength: 20)
            Grid(horizontalSpacing: 10.horizontallyAdjusted, verticalSpacing: 10.horizontallyAdjusted) {
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
        }
        .padding([.horizontal, .top], 20)
        .setBackgroundColor(.background)
    }
}

// MARK: ViewBuilder

extension ReviewView {
    
    @ViewBuilder
    private func emojiImage(_ emoji: Emoji) -> some View {
        Image(emoji.rawValue)
            .resizable()
            .frame(width: 100.horizontallyAdjusted, height: 100.horizontallyAdjusted)
    }
    
    @ViewBuilder
    private func emojiButton(_ emoji: Emoji) -> some View {
        Button {
            viewModel.selectedEmoji = emoji
            viewModel.updateChallenge()
            viewModel.navigate()
        } label: {
            if viewModel.selectedEmoji == emoji {
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
        ReviewView(viewModel: ReviewViewModel(
            from: .addTab,
            challenge: Challenge(
                id: UUID(),
                date: Date(),
                content: "Preview",
                emoji: .none
            ),
            navigationController: nil
        ))
    }
}
#endif
