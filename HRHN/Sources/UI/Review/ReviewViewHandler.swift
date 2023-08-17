//
//  ReviewViewHandler.swift
//  HRHN
//
//  Created by 민채호 on 6/19/23.
//

import Combine

final class ReviewViewHandler {
    
    let sheetWillPresentSubject = PassthroughSubject<Void, Never>()
    let sheetWillDismissSubject = PassthroughSubject<Void, Never>()
    let editButtonDidTapSubject = PassthroughSubject<Void, Never>()
    let deleteButtonDidTapSubject = PassthroughSubject<Void, Never>()
}
