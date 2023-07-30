//
//  TopStyle.swift
//  ChartsStudy
//
//  Created by 김영빈 on 2023/07/31.
//

import Charts
import SwiftUI

let data = [
    (name: "Cachapa", sales: 916),
    (name: "Injera", sales: 850),
    (name: "Crepe", sales: 802),
    (name: "Jian Bing", sales: 750),
    (name: "Dosa", sales: 700),
    (name: "American", sales: 650)
]
struct TopStyle: View {
    var body: some View {
        GroupBox("Most Sold Style") {
            Text("Cachapa")
            Chart {
                ForEach(data, id: \.name) {
                    BarMark(
                        x: .value("Sales", $0.sales),
                        y: .value("Name", $0.name)
                    )
                    .foregroundStyle(Color.red) // 색깔 설정
                    .accessibilityLabel($0.name) // VoiceOver 사용자에게 전달될 값을 직접 지정
                    .accessibilityValue("\($0.sales) sold") // VoiceOver 사용자에게 전달될 값을 직접 지정
                }
            }
        }
    }
}

struct TopStyle_Previews: PreviewProvider {
    static var previews: some View {
        TopStyle()
    }
}
