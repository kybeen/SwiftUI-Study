//
//  CupertinoDetails.swift
//  ChartsStudy
//
//  Created by 김영빈 on 2023/07/30.
//

import Charts
import SwiftUI

struct SalesSummary: Identifiable {
    let weekday: String
    let sales: Int
    
    var id: UUID = UUID()
}

let cupertinoData: [SalesSummary] = [
    /// Monday
    .init(weekday: Date().date(2022, 5, 2).getWeekday(), sales: 54),
    /// Tuesday
    .init(weekday: Date().date(2022, 5, 3).getWeekday(), sales: 42),
    /// Wednesday
    .init(weekday: Date().date(2022, 5, 4).getWeekday(), sales: 88),
    /// Thursday
    .init(weekday: Date().date(2022, 5, 5).getWeekday(), sales: 49),
    /// Friday
    .init(weekday: Date().date(2022, 5, 6).getWeekday(), sales: 42),
    /// Saturday
    .init(weekday: Date().date(2022, 5, 7).getWeekday(), sales: 125),
    /// Sunday
    .init(weekday: Date().date(2022, 5, 8).getWeekday(), sales: 67)
]

struct CupertinoDetailsChart: View {
    var body: some View {
        Chart(cupertinoData) { element in
            BarMark(
                x: .value("Day", element.weekday),
                y: .value("Sales", element.sales)
            )
        }
    }
}

struct CupertinoDetailsChart_Previews: PreviewProvider {
    static var previews: some View {
        CupertinoDetailsChart()
    }
}

extension Date {
    func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        let finalDate = calendar.date(from: dateComponents)!
        return finalDate
    }
    
    func getWeekday() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE" // Use "EEE" for short weekday symbols (e.g., "Sun", "Mon", etc.)
        return dateFormatter.string(from: self)
    }
}
