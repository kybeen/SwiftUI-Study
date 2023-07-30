//
//  TeringChartView.swift
//  ChartsStudy
//
//  Created by 김영빈 on 2023/07/31.
//

import Charts
import SwiftUI

enum Period {
    case week
    case month
    case sixMonths
    case year
}
enum SwingRecordType {
    case totalSwing
    case perfectSwing
}
struct CountData: Identifiable {
    let weekday: String
    let count: Int
    
    var id: UUID = UUID()
}
struct weekPerSwingType: Identifiable {
    let swingRecordType: String
    let countData: [CountData]
    
    var id: UUID = UUID()
}

let totalSwingData: [CountData] = [
    .init(weekday: Date().date2(2023,7,24).getWeekday2(), count: 150),
    .init(weekday: Date().date2(2023,7,25).getWeekday2(), count: 124),
    .init(weekday: Date().date2(2023,7,26).getWeekday2(), count: 135),
    .init(weekday: Date().date2(2023,7,27).getWeekday2(), count: 104),
    .init(weekday: Date().date2(2023,7,28).getWeekday2(), count: 140),
    .init(weekday: Date().date2(2023,7,29).getWeekday2(), count: 90),
    .init(weekday: Date().date2(2023,7,30).getWeekday2(), count: 110),
]
let perfectSwingData: [CountData] = [
    .init(weekday: Date().date2(2023,7,24).getWeekday2(), count: 135),
    .init(weekday: Date().date2(2023,7,25).getWeekday2(), count: 110),
    .init(weekday: Date().date2(2023,7,26).getWeekday2(), count: 120),
    .init(weekday: Date().date2(2023,7,27).getWeekday2(), count: 97),
    .init(weekday: Date().date2(2023,7,28).getWeekday2(), count: 126),
    .init(weekday: Date().date2(2023,7,29).getWeekday2(), count: 78),
    .init(weekday: Date().date2(2023,7,30).getWeekday2(), count: 98),
]

let weekPerSwingTypeData: [weekPerSwingType] = [
    .init(swingRecordType: "전체 스윙 횟수", countData: totalSwingData),
    .init(swingRecordType: "퍼펙트 스윙 횟수", countData: perfectSwingData)
]

struct TeringChartView: View {
    @State var period: Period = .week
    
    var body: some View {
        VStack {
            Picker("Period", selection: $period.animation(.easeInOut)) {
                Text("1주").tag(Period.week)
                Text("1개월").tag(Period.month)
                Text("6개월").tag(Period.sixMonths)
                Text("1년").tag(Period.year)
            }
            .pickerStyle(.segmented)
            Chart(weekPerSwingTypeData) { eachGraph in
                ForEach(eachGraph.countData) { element in
                    BarMark(
                        x: .value("Day", element.weekday),
                        y: .value("Count", element.count)
                    )
                    .cornerRadius(5)
                    .foregroundStyle(by: .value("Swing Record Type", eachGraph.swingRecordType))
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height*0.5)
        .padding()
    }
}

struct TeringChartView_Previews: PreviewProvider {
    static var previews: some View {
        TeringChartView()
    }
}

extension Date {
    func date2(_ year: Int, _ month: Int, _ day: Int) -> Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        let finalDate = calendar.date(from: dateComponents)!
        return finalDate
    }

    func getWeekday2() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE" // Use "EEE" for short weekday symbols (e.g., "Sun", "Mon", etc.)
//        return dateFormatter.string(from: self)
        
        var engLabel = dateFormatter.string(from: self)
        switch engLabel {
        case "Mon":
            return "월"
        case "Tue":
            return "화"
        case "Wed":
            return "수"
        case "Thu":
            return "목"
        case "Fri":
            return "금"
        case "Sat":
            return "토"
        case "Sun":
            return "일"
        default:
            return ""
        }
    }
}





