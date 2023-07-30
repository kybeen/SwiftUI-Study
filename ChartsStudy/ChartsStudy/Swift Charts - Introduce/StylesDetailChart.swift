//
//  StylesDetailChart.swift
//  ChartsStudy
//
//  Created by 김영빈 on 2023/07/30.
//

import Charts
import SwiftUI

struct Pancakes: Identifiable { // Identifiable : 반복해서 사용하기 위함
    let name: String
    let sales: Int
    
    var id: String { name }
}

let sales: [Pancakes] = [
    .init(name: "Cachapa", sales: 916),
    .init(name: "Injera", sales: 850),
    .init(name: "Crepe", sales: 802),
    .init(name: "Jian Bing", sales: 753),
    .init(name: "Dosa", sales: 654),
    .init(name: "American", sales: 618)
]

struct StylesDetailChart: View {
    var body: some View {
        // Charts 내부에서 ForEach 구문을 직접 써도 됨
        Chart(sales) { element in
            // 각각의 표시 요소는 Mark라고 한다.
            BarMark(
                // .value : 막대의 길이나 높이를 직접 설정하지 않는다는 의미
                // x축과 y축을 바꾸면 차트의 방향이 바뀜
                x: .value("Name", element.name), // .value의 왼쪽 파라미터는 값에 대한 설명
                y: .value("Sales", element.sales)
            )
        }
    }
}

struct StylesDetailChart_Previews: PreviewProvider {
    static var previews: some View {
        StylesDetailChart()
    }
}
