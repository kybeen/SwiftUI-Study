//
//  ContentView.swift
//  DeviceMotionCollector
//
//  Created by 김영빈 on 2023/07/08.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var phoneViewModel = PhoneViewModel()
    @State var reachable = "No"
    
    var body: some View {
        VStack {
            HStack {
                Button("Update") {
                    if self.phoneViewModel.session.isReachable {
                        self.reachable = "Yes"
                        print("YES!!!")
                    } else {
                        self.reachable = "No"
                        print("NO...")
                    }
                }
                Text("Reachable: \(reachable)")
            }
            .padding()
            Text("Received data").font(.title)
            Text("Activity class : \(phoneViewModel.activityType)").bold()
            Text("Hand type : \(phoneViewModel.handType)").bold()
            
//            ScrollView {
//                Text(phoneViewModel.csvString)
//            }
            Text("CSV file name : \(phoneViewModel.csvFileName)").bold()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
