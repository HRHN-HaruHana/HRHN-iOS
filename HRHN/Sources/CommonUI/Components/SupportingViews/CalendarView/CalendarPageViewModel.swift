//
//  CalendarPageViewModel.swift
//  HRHN
//
//  Created by 민채호 on 2023/04/20.
//

import Foundation
import SwiftUI

final class CalendarPageViewModel: ObservableObject {
    
}

extension CalendarPageViewModel {
    
    func addMonths(_ months: Int, to date: Date) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: date) ?? Date()
    }
}
