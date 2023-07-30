//
//  LocationDetailsChart.swift
//  ChartsStudy
//
//  Created by 김영빈 on 2023/07/31.
//

import Charts
import SwiftUI

struct Series: Identifiable {
    let city: String
    let sales: [SalesSummary]
    
    var id: String { city }
}

let seriesData: [Series] = [
    .init(city: "Cupertino", sales: cupertinoData),
    .init(city: "San Francisco", sales: sfData),
]

struct LocationDetailsChart: View {
    var body: some View {
        Chart(seriesData) { series in
            ForEach(series.sales) { element in
                //MARK: 값에 따라 2개의 바차트를 다른 색으로 동시에 표시
                BarMark(
                    x: .value("Day", element.weekday),
                    y: .value("Sales", element.sales)
                )
                .foregroundStyle(by: .value("City", series.city))
                
//                //MARK: PointMark와 LineMark 같이 써서 표시
//                PointMark(
//                    x: .value("Day", element.weekday),
//                    y: .value("Sales", element.sales)
//                )
//                .foregroundStyle(by: .value("City", series.city)) // 값에 따라 다른 색으로 표시
//                .symbol(by: .value("City", series.city)) // 값에 따라 다른 점으로 표시
//                LineMark(
//                    x: .value("Day", element.weekday),
//                    y: .value("Sales", element.sales)
//                )
//                .foregroundStyle(by: .value("City", series.city))

//                //MARK: 모디파이어를 사용해서 LineMark만 써서 PointMark도 같이 표시
//                LineMark(
//                    x: .value("Day", element.weekday),
//                    y: .value("Sales", element.sales)
//                )
//                .foregroundStyle(by: .value("City", series.city)) // 값에 따라 다른 색으로 표시
//                .symbol(by: .value("City", series.city)) // 값에 따라 다른 점으로 표시
            }
        }
    }
}

struct LocationDetailsChart_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailsChart()
    }
}


