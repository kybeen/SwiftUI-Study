//
//  GraphView.swift
//  CoreMotionTest
//
//  Created by 김영빈 on 2023/07/03.
//

import SwiftUI

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

//struct GraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphView()
//    }
//}
