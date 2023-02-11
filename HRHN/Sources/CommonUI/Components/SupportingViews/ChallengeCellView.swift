//
//  ChallengeCellView.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/23.
//

import SwiftUI

struct ChallengeCellView: View {
    
    var challenge: Challenge
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .center) {
                Image(challenge.emoji.name)
                    .resizable()
                    .frame(width: 50, height: 50)
                Text(challenge.date.formatted("MM/dd"))
                    .font(.system(size: 10, weight: .regular))
            }
            Text(challenge.content)
                .font(.system(size: 16, weight: .regular))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .foregroundColor(.cellLabel)
                
        }
        .padding(20)
        .background(Color.cellFill)
        .cornerRadius(16)
    }
}

#if DEBUG
struct ChallengeCellView_Previews: PreviewProvider {
    static var previews: some View {
//        List {
        ChallengeCellView(challenge: Challenge.mock[1])
//        }
    }
}
#endif
