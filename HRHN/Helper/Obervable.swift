//
//  Obervable.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/25.
//

import Foundation

class Observable<T> {
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    private var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func subscribe(_ closure: @escaping (T) -> Void) {
        closure(value) // listener
        listener = closure
    }
    
}
