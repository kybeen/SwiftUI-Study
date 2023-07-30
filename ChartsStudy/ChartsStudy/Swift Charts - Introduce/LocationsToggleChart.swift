//
//  LocationsToggle.swift
//  ChartsStudy
//
//  Created by 김영빈 on 2023/07/30.
//

import Charts
import SwiftUI

enum City {
    case cupertino
    case sanFrancisco
}

let sfData: [SalesSummary] = [
    .init(weekday: Date().date(2022, 5, 2).getWeekday(), sales: 81),
    .init(weekday: Date().date(2022, 5, 3).getWeekday(), sales: 90),
    .init(weekday: Date().date(2022, 5, 4).getWeekday(), sales: 52),
    .init(weekday: Date().date(2022, 5, 5).getWeekday(), sales: 72),
    .init(weekday: Date().date(2022, 5, 6).getWeekday(), sales: 84),
    .init(weekday: Date().date(2022, 5, 7).getWeekday(), sales: 84),
    .init(weekday: Date().date(2022, 5, 8).getWeekday(), sales: 137)
]

struct LocationsToggleChart: View {
    @State var city: City = .cupertino
    
    var data: [SalesSummary] {
        switch city {
        case .cupertino:
            return cupertinoData
        case .sanFrancisco:
            return sfData
        }
    }
    
    var body: some View {
        VStack {
            Picker("City", selection: $city.animation(.easeInOut)) {
                Text("Cupertino").tag(City.cupertino)
                Text("San Francisco").tag(City.sanFrancisco)
            }
            .pickerStyle(.segmented)
            Chart(data) { element in
                BarMark(
                    x: .value("Day", element.weekday),
                    y: .value("Sales", element.sales)
                )
            }
        }
    }
}

struct LocationsToggleChart_Previews: PreviewProvider {
    static var previews: some View {
        LocationsToggleChart()
    }
}
