//
//  WatchConnet.swift
//  CoreMotionTest
//
//  Created by 김영빈 on 2023/07/05.
//

import SwiftUI

struct WatchConnectivityTestView: View {
    @StateObject private var viewModel = WatchConnectivityViewModel()
    
    var body: some View {
        VStack {
            Text("Acceleration X: \(viewModel.accelerationX)")
            Text("Acceleration Y: \(viewModel.accelerationY)")
            Text("Acceleration Z: \(viewModel.accelerationZ)")
        }
    }
}

struct WatchConnectivityTestView_Previews: PreviewProvider {
    static var previews: some View {
        WatchConnectivityTestView()
    }
}
