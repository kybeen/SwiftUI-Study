//
//  ContentView.swift
//  CoreMotionTest
//
//  Created by 김영빈 on 2023/07/01.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection: Tab = .motionManager
    enum Tab {
        case motionManager
        case batchedSensorManager
    }
    
    var body: some View {
        TabView(selection: $tabSelection) {
            AccelerationView()
                .tabItem {
                    Text("Motion")
                }

            RotationRateView()
                .tabItem {
                    Text("Graph")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
