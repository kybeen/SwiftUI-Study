//
//  WatchConnet.swift
//  CoreMotionTest
//
//  Created by 김영빈 on 2023/07/05.
//

/* watchOS 앱에서 받아온 가속도계 센서값을 확인하는 뷰 */
import SwiftUI

struct WatchConnectivityTestView: View {
    @ObservedObject var viewModel = ViewModelPhone()

    @State private var scrollWidth: CGFloat = UIScreen.main.bounds.width
    
    @State private var isSwinging = false
    @State private var isUpdating = false
    
    var body: some View {
        VStack {
            Text("Accelerometers")
                .font(.largeTitle)
                .bold()
            
            Text(isSwinging ? "Swinging" : "Not Swinging")
                .font(.title2)
                .foregroundColor(isSwinging ? .green : .red)
            
            Text("Acceleration").bold()
            Text("X: \(viewModel.watchAccelerationX), Y: \(viewModel.watchAccelerationY), Z: \(viewModel.watchAccelerationZ)")
            
            VStack {
                Text("X").bold()
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(viewModel.watchAccX.indices, id: \.self) { index in
                            GraphView(dataPoints: viewModel.watchAccX[index])
                                .frame(width: UIScreen.main.bounds.width, height: 120)
                        }
                    }
                }
                .frame(width: scrollWidth, height: 120)
                Text("Y").bold()
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(viewModel.watchAccY.indices, id: \.self) { index in
                            GraphView(dataPoints: viewModel.watchAccY[index])
                                .frame(width: UIScreen.main.bounds.width, height: 120)
                        }
                    }
                }
                .frame(width: scrollWidth, height: 120)
                Text("Z").bold()
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(viewModel.watchAccZ.indices, id: \.self) { index in
                            GraphView(dataPoints: viewModel.watchAccZ[index])
                                .frame(width: UIScreen.main.bounds.width, height: 120)
                        }
                    }
                }
                .frame(width: scrollWidth, height: 120)
            }
        }
    }
}

struct WatchConnectivityTestView_Previews: PreviewProvider {
    static var previews: some View {
        WatchConnectivityTestView()
    }
}
