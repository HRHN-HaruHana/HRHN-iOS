//
//  ChallengeCellView.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/23.
//

import SwiftUI
import UIKit

struct ChallengeCellView: View {
    
    var challenge: Challenge
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .center) {
                Image("purple")
                    .resizable()
                    .frame(width: 50, height: 50)
                Text(challenge.date.formatted("MM/dd"))
                    .font(.system(size: 10, weight: .regular))
            }
            Text(challenge.content)
                .font(.system(size: 16, weight: .regular))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color(UIColor.challengeListLabel!))
                
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .background(Color(UIColor.challngeListFill!))
        .cornerRadius(16)
    }
}

#if DEBUG
struct ChallengeCellView_Previews: PreviewProvider {
    static var previews: some View {
//        List {
        ChallengeCellView(challenge: Challenge.mock[0])
//        }
    }
}
#endif
