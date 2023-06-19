//
//  ReserveChallengeViewHandler.swift
//  HRHN
//
//  Created by 민채호 on 6/18/23.
//

import Combine

final class ReserveChallengeViewHandler {
    
    let sheetWillPresentSubject = PassthroughSubject<Void, Never>()
    let sheetDidDismissSubject = PassthroughSubject<Void, Never>()
    let deleteButtonDidTapSubject = PassthroughSubject<Void, Never>()
}
