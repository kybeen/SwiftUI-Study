//
//  ContentView.swift
//  TennisClassifierTest
//
//  Created by 김영빈 on 2023/07/12.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var phoneViewModel = PhoneViewModel()
    @State var reachable = "No"
    
    var body: some View {
        VStack {
            Text("Class: \(phoneViewModel.forehandLabel)").font(.largeTitle)
            Text("Confidence: \(phoneViewModel.confidence)").font(.largeTitle)
            Text("Forehand Count: \(phoneViewModel.forehandCount)").font(.largeTitle)
            HStack {
                Button("Update") {
                    if phoneViewModel.session.isReachable {
                        reachable = "Yes"
                    } else {
                        reachable = "No"
                    }
                }
                Text("\(reachable)")
            }
            .padding()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
