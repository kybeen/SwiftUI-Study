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
        VStack(alignment: .leading) {
            HStack {
                Text("Swing type: ").bold().font(.largeTitle)
                Text("\(phoneViewModel.classLabel)").font(.largeTitle)
            }
            HStack {
                Text("Result: ").bold().font(.largeTitle)
                Text("\(phoneViewModel.resultLabel)").font(.largeTitle)
            }
            HStack {
                Text("Prob: ").bold().font(.largeTitle)
                Text("\(phoneViewModel.confidence)").font(.largeTitle)
            }
            HStack {
                Text("Perfect Count: ").bold().font(.largeTitle)
                Text("\(phoneViewModel.perfectCount)").font(.largeTitle)
            }
            HStack {
                Text("Bad Count: ").bold().font(.largeTitle)
                Text("\(phoneViewModel.badCount)").font(.largeTitle)
            }
            HStack {
                Text("Total Swing: ").bold().font(.largeTitle)
                Text("\(phoneViewModel.totalCount)").font(.largeTitle)
            }
            HStack {
                Button {
                    if phoneViewModel.session.isReachable {
                        reachable = "Yes"
                    } else {
                        reachable = "No"
                    }
                } label: {
                    Text("Update").bold().font(.title)
                }
                Text("➡️ \(reachable)").font(.title)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
