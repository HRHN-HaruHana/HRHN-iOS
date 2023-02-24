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
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(viewModel.challenge.content)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(.cellLabel)
                .frame(maxWidth: .infinity)
                .frame(height: 136.verticallyAdjusted)
            HStack(spacing: 10) {
                emojiButton(.success)
                emojiButton(.tried)
                emojiButton(.fail)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: ViewBuilder

extension ReviewView {
    
    @ViewBuilder
    private func emojiStack(_ emoji: Emoji) -> some View {
        VStack(spacing: 10) {
            Image(emoji.rawValue)
                .resizable()
                .frame(width: 80.verticallyAdjusted, height: 80.verticallyAdjusted)
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                switch emoji {
                case .success:
                    Text(I18N.challengeSuccess)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(viewModel.selectedEmoji == .success ? .whiteLabel : .cellLabel)
                case .tried:
                    Text(I18N.challengeTried)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(viewModel.selectedEmoji == .tried ? .whiteLabel : .cellLabel)
                case .fail:
                    Text(I18N.challengeFail)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(viewModel.selectedEmoji == .fail ? .whiteLabel : .cellLabel)
                default:
                    Text("none")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                }
                Image(Assets.dot)
                    .resizable()
                    .frame(width: 4, height: 4)
            }
        }
        .padding(10)
        .background {
            if viewModel.selectedEmoji == emoji {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.dim)
            }
        }
    }
    
    @ViewBuilder
    private func emojiButton(_ emoji: Emoji) -> some View {
        Button {
            viewModel.selectedEmoji = emoji
            viewModel.updateChallenge()
            viewModel.navigate()
        } label: {
            emojiStack(emoji)
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
