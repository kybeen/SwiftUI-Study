//
//  TeringChartView.swift
//  ChartsStudy
//
//  Created by 김영빈 on 2023/07/31.
//

//import Charts
//import SwiftUI
//import UIKit
//
//enum Period {
//    case week
//    case month
//    case sixMonths
//    case year
//}
//struct WeekSwingData: Identifiable {
//    let weekday: String
//    let totalCount: Int
//    let perfectCount: Int
//
//    var id: UUID = UUID()
//}
//
//let weekSwingData: [WeekSwingData] = [
//    .init(weekday: Date().date2(2023,7,24).getWeekday2(), totalCount: 250, perfectCount: 140),
//    .init(weekday: Date().date2(2023,7,25).getWeekday2(), totalCount: 124, perfectCount: 100),
//    .init(weekday: Date().date2(2023,7,26).getWeekday2(), totalCount: 135, perfectCount: 110),
//    .init(weekday: Date().date2(2023,7,27).getWeekday2(), totalCount: 104, perfectCount: 90),
//    .init(weekday: Date().date2(2023,7,28).getWeekday2(), totalCount: 170, perfectCount: 80),
//    .init(weekday: Date().date2(2023,7,29).getWeekday2(), totalCount: 90, perfectCount: 70),
//    .init(weekday: Date().date2(2023,7,30).getWeekday2(), totalCount: 110, perfectCount: 100),
//]
//
//struct TeringChartView: View {
////    @State var period: Period = .week
//    @State private var selectedIndex = 0
//    private var periodSelections = ["1주", "1개월", "6개월", "1년"]
//
//    var totalSwingAverage = 0
//    var perfectSwingAverage = 0
//
//    init() {
//        var totalSum = 0
//        var perfectSum = 0
//        for each in weekSwingData {
//            totalSum += each.totalCount
//            perfectSum += each.perfectCount
//        }
//        totalSwingAverage = totalSum / weekSwingData.count
//        perfectSwingAverage = perfectSum / weekSwingData.count
//    }
//    var body: some View {
//        VStack {
////            Picker("Period", selection: $period.animation(.easeInOut)) {
////                Text("1주").tag(Period.week)
////                Text("1개월").tag(Period.month)
////                Text("6개월").tag(Period.sixMonths)
////                Text("1년").tag(Period.year)
////            }
////            .pickerStyle(.segmented)
////            .colorMultiply(Color(uiColor: UIColor(hex: 0x3EF23B))) // 완전 커스텀은 UIKit 필요한듯
//            CustomSegmentedView($selectedIndex, selections: periodSelections)
//
//            Chart {
//                ForEach(weekSwingData) { element in
//                    BarMark(
//                        x: .value("Day", element.weekday),
//                        y: .value("Total Count", element.totalCount),
//                        stacking: .unstacked // 바 차트 겹쳐서 보도록
//                    )
//                    .cornerRadius(5)
//                    .foregroundStyle(.linearGradient(colors: [Color(uiColor: UIColor(hex: 0x3FF23D)), .black], startPoint: .init(x: 0.5, y: 0.0), endPoint: .init(x: 0.5, y: 0.8))) // 초록
//
//                    BarMark(
//                        x: .value("Day", element.weekday),
//                        y: .value("Perfect Count", element.perfectCount),
//                        stacking: .unstacked
//                    )
//                    .cornerRadius(5)
//                    .foregroundStyle(.linearGradient(colors: [Color(uiColor: UIColor(hex: 0x3AE0F1)), .black], startPoint: .init(x: 0.5, y: 0), endPoint: .init(x: 0.5, y: 1.2))) // 파랑
//                }
//
//                RuleMark(
//                    y: .value("Total Average", totalSwingAverage)
//                )
//                .foregroundStyle(Color(uiColor: UIColor(hex: 0x3EF23B))) // 초록
//                .lineStyle(StrokeStyle(lineWidth: 2.5, dash: [2]))
////                .annotation(position: .leading, alignment: .leading) {
////                    Text("전체 스윙 평균: \(totalSwingAverage, format: .number)")
////                        .font(.headline)
////                        .foregroundStyle(Color(uiColor: UIColor(hex: 0x3EF23B))) // 초록
////                }
//
//                RuleMark(
//                    y: .value("Perfect Average", perfectSwingAverage)
//                )
//                .foregroundStyle(Color(uiColor: UIColor(hex: 0x39B5FA))) // 파랑
//                .lineStyle(StrokeStyle(lineWidth: 2.5, dash: [2]))
//            }
//        }
//        .frame(height: UIScreen.main.bounds.height*0.5)
//        .padding()
//    }
//}
//
//struct TeringChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        TeringChartView()
//    }
//}
//
//extension Date {
//    func date2(_ year: Int, _ month: Int, _ day: Int) -> Date {
//        let calendar = Calendar.current
//        var dateComponents = DateComponents()
//        dateComponents.year = year
//        dateComponents.month = month
//        dateComponents.day = day
//        let finalDate = calendar.date(from: dateComponents)!
//        return finalDate
//    }
//
//    func getWeekday2() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEE" // Use "EEE" for short weekday symbols (e.g., "Sun", "Mon", etc.)
////        return dateFormatter.string(from: self)
//
//        var engLabel = dateFormatter.string(from: self)
//        switch engLabel {
//        case "Mon":
//            return "월"
//        case "Tue":
//            return "화"
//        case "Wed":
//            return "수"
//        case "Thu":
//            return "목"
//        case "Fri":
//            return "금"
//        case "Sat":
//            return "토"
//        case "Sun":
//            return "일"
//        default:
//            return ""
//        }
//    }
//}
//
//extension UIColor {
//    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
//        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
//        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
//        let blue = CGFloat(hex & 0x0000FF) / 255.0
//        self.init(red: red, green: green, blue: blue, alpha: alpha)
//    }
//}
//
////MARK: 커스텀 Segmented Picker
//struct CustomSegmentedView: View {
//    @Binding var currentIndex: Int
//    var selections: [String]
//
//    init(_ currentIndex: Binding<Int>, selections: [String]) {
//        self._currentIndex = currentIndex
//        self.selections = selections
//        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(hex: 0x3EF23B) // 선택 색상
////        UISegmentedControl.appearance().backgroundColor = UIColor(Color.orange.opacity(0.3)) // 배경 색상
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.black)], for: .selected) // 선택 텍스트 색상
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.white)], for: .normal) // 그 외 텍스트 색상
//    }
//
//    var body: some View {
//        VStack {
//            Picker("", selection: $currentIndex) {
//                ForEach(selections.indices, id: \.self) { index in
//                    Text(selections[index])
//                        .tag(index)
//                        .foregroundColor(Color.blue)
//                }
//            }
//            .pickerStyle(.segmented)
//        }
//    }
//}










//MARK: 그래프 하단에 종류별로 해당 색상 표시해주는 버전 (색상 커스텀은 못하는듯)
import Charts
import SwiftUI
import UIKit

enum Period {
    case week
    case month
    case sixMonths
    case year
}
struct WeekSwingData: Identifiable {
    let weekday: String
    let count: Int

    var id: UUID = UUID()
}
struct WeekPerSwingDataType: Identifiable {
    let swingDataType: String
    let data: [WeekSwingData]

    var id: UUID = UUID()
}
let totalData: [WeekSwingData] = [
    .init(weekday: Date().date2(2023,7,24).getWeekday2(), count: 250),
    .init(weekday: Date().date2(2023,7,25).getWeekday2(), count: 124),
    .init(weekday: Date().date2(2023,7,26).getWeekday2(), count: 135),
    .init(weekday: Date().date2(2023,7,27).getWeekday2(), count: 104),
    .init(weekday: Date().date2(2023,7,28).getWeekday2(), count: 140),
    .init(weekday: Date().date2(2023,7,29).getWeekday2(), count: 90),
    .init(weekday: Date().date2(2023,7,30).getWeekday2(), count: 110),
]
let perfectData: [WeekSwingData] = [
    .init(weekday: Date().date2(2023,7,24).getWeekday2(), count: 200),
    .init(weekday: Date().date2(2023,7,25).getWeekday2(), count: 100),
    .init(weekday: Date().date2(2023,7,26).getWeekday2(), count: 110),
    .init(weekday: Date().date2(2023,7,27).getWeekday2(), count: 90),
    .init(weekday: Date().date2(2023,7,28).getWeekday2(), count: 80),
    .init(weekday: Date().date2(2023,7,29).getWeekday2(), count: 70),
    .init(weekday: Date().date2(2023,7,30).getWeekday2(), count: 100),
]
let weekPerSwingDataType: [WeekPerSwingDataType] = [
    .init(swingDataType: "전체 스윙 횟수", data: totalData),
    .init(swingDataType: "퍼펙트 스윙 횟수", data: perfectData)
]

struct TeringChartView: View {
//    @State var period: Period = .week
    @State private var selectedIndex = 0
    private var periodSelections = ["1주", "1개월", "6개월", "1년"]
    
    var totalSwingAverage = 0
    var perfectSwingAverage = 0

    init() {
        var totalSum = 0
        var perfectSum = 0
        for each in weekPerSwingDataType {
            if each.swingDataType == "전체 스윙 횟수" {
                for eachData in each.data {
                    totalSum += eachData.count
                }
            } else {
                for eachData in each.data {
                    perfectSum += eachData.count
                }
            }
        }
        totalSwingAverage = totalSum / totalData.count
        perfectSwingAverage = perfectSum / perfectData.count
    }
    var body: some View {
        VStack {
//            Picker("Period", selection: $period.animation(.easeInOut)) {
//                Text("1주").tag(Period.week)
//                Text("1개월").tag(Period.month)
//                Text("6개월").tag(Period.sixMonths)
//                Text("1년").tag(Period.year)
//            }
//            .pickerStyle(.segmented)
            CustomSegmentedView($selectedIndex, selections: periodSelections)

            Chart {
                ForEach(weekPerSwingDataType) { eachType in
                    ForEach(eachType.data) { element in
                        BarMark(
                            x: .value("Day", element.weekday),
                            y: .value("Count", element.count),
                            stacking: .unstacked // 바 차트 겹쳐서 보도록
                        )
                        .cornerRadius(5)
                        .foregroundStyle(by: .value("Swing Type", eachType.swingDataType)) // 색 지정이 안되는것 같음
                    }
                }
                RuleMark(
                    y: .value("Total Average", totalSwingAverage)
                )
                .foregroundStyle(Color(uiColor: UIColor(hex: 0x3EF23B))) // 초록
                .lineStyle(StrokeStyle(dash: [2]))
//                .annotation(position: .leading, alignment: .leading) {
//                    Text("전체 스윙 평균: \(totalSwingAverage, format: .number)")
//                        .font(.headline)
//                        .foregroundStyle(Color(uiColor: UIColor(hex: 0x3EF23B))) // 초록
//                }

                RuleMark(
                    y: .value("Perfect Average", perfectSwingAverage)
                )
                .foregroundStyle(Color(uiColor: UIColor(hex: 0x39B5FA))) // 파랑
                .lineStyle(StrokeStyle(dash: [2]))
            }
            .chartForegroundStyleScale([
                "전체 스윙 횟수": .linearGradient(colors: [Color(uiColor: UIColor(hex: 0x3FF23D)), .black], startPoint: .init(x: 0.5, y: 0.0), endPoint: .init(x: 0.5, y: 0.8)),
                "퍼펙트 스윙 횟수": .linearGradient(colors: [Color(uiColor: UIColor(hex: 0x3AE0F1)), .black], startPoint: .init(x: 0.5, y: 0), endPoint: .init(x: 0.5, y: 1.2))
            ])
//            .chartLegend(position: .top, alignment: .leading) {
//                Text("2023년 7월 4일~10일").font(.system(size: 12))
//                    .foregroundColor(Color(uiColor: UIColor(hex: 0xADADAD)))
//            } // 제목 달기 (이거 하면 색상별 표시 항목 가이드 사라짐)
//            .chartYAxis(.hidden) // Y축 값 숨기기
            .padding()
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

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

//MARK: 커스텀 Segmented Picker
struct CustomSegmentedView: View {
    @Binding var currentIndex: Int
    var selections: [String]

    init(_ currentIndex: Binding<Int>, selections: [String]) {
        self._currentIndex = currentIndex
        self.selections = selections
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(hex: 0x3EF23B) // 선택 색상
//        UISegmentedControl.appearance().backgroundColor = UIColor(Color.orange.opacity(0.3)) // 배경 색상
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.black)], for: .selected) // 선택 텍스트 색상
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.white)], for: .normal) // 그 외 텍스트 색상
    }

    var body: some View {
        VStack {
            Picker("", selection: $currentIndex) {
                ForEach(selections.indices, id: \.self) { index in
                    Text(selections[index])
                        .tag(index)
                        .foregroundColor(Color.blue)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}
