//
//  EditViewHandler.swift
//  HRHN
//
//  Created by 민채호 on 6/18/23.
//

import Combine

final class EditViewHandler {
    
    let sheetWillPresentSubject = PassthroughSubject<Void, Never>()
    let sheetWillDismissSubject = PassthroughSubject<Void, Never>()
    let deleteButtonDidTapSubject = PassthroughSubject<Void, Never>()
}
