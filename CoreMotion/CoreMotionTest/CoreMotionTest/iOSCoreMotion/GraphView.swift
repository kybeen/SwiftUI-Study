//
//  GraphView.swift
//  CoreMotionTest
//
//  Created by 김영빈 on 2023/07/03.
//

/* 그래프 뷰 */
import SwiftUI
import Charts

struct GraphView: View {
    var dataPoints: [Double]

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let xScale = geometry.size.width / CGFloat(dataPoints.count)
                let yScale = geometry.size.height // Assuming max value

                path.move(to: CGPoint(x: 0, y: geometry.size.height))

                for (index, dataPoint) in dataPoints.enumerated() {
                    let x = CGFloat(index) * xScale
                    let y = geometry.size.height - CGFloat(dataPoint) * yScale - (geometry.size.height*0.5)
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(Color.blue, lineWidth: 2)
        }
    }
}
//
//struct DeviceMotionData: Identifiable {
//    var type: String
//    var count: Double
//    var id = UUID()
//}
//
//struct GraphView: View {
//    var timestamp: [Int]
//    var dataPoints: [Double]
//    
//    var body: some View {
//    }
//}
//
//struct GraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphView(
//            timestamp: [1, 2, 3, 4, 5],
//            dataPoints: [0.1, 0.2, 0.3, 0.4, 0.6]
//        )
//    }
//}
