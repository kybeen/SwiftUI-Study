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
            Text("Class: \(phoneViewModel.forehandLabel)")
            Text("Confidence: \(phoneViewModel.confidence)")
            Text("Forehand Count: \(phoneViewModel.forehandCount)")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
