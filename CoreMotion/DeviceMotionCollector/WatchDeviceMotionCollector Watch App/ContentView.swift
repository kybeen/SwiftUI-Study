//
//  ContentView.swift
//  WatchDeviceMotionCollector Watch App
//
//  Created by 김영빈 on 2023/07/08.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            LeftHandView()
            RightHandView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
