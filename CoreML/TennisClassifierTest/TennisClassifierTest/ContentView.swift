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
        VStack(alignment: .trailing) {
            HStack {
                Text("Swing type: ").bold().font(.largeTitle)
                Spacer()
                Text("\(phoneViewModel.classLabel)").font(.largeTitle)
            }
            HStack {
                Text("Result: ").bold().font(.largeTitle)
                Spacer()
                Text("\(phoneViewModel.resultLabel)").font(.largeTitle)
            }
            HStack {
                Text("Probability: ").bold().font(.largeTitle)
                Spacer()
                Text("\(String(phoneViewModel.confidence.prefix(8)))").font(.title)
            }
            HStack {
                Text("Forehand: ").bold().font(.largeTitle).padding(.trailing, 10)
                Spacer()
                VStack {
                    Text("Perfect")
                    Text("\(phoneViewModel.forehandPerfectCount)")
                }.bold().foregroundColor(.green).padding(.trailing, 10)
                VStack {
                    Text("Bad")
                    Text("\(phoneViewModel.forehandBadCount)")
                }.bold().foregroundColor(.red)
            }
            HStack {
                Text("Backhand: ").bold().font(.largeTitle).padding(.trailing, 10)
                Spacer()
                VStack {
                    Text("Perfect")
                    Text("\(phoneViewModel.backhandPerfectCount)")
                }.bold().foregroundColor(.green).padding(.trailing, 10)
                VStack {
                    Text("Bad")
                    Text("\(phoneViewModel.backhandBadCount)")
                }.bold().foregroundColor(.red)
            }
            HStack {
                Text("Total Swing: ").bold().font(.largeTitle)
                Spacer()
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
            .padding(.top, 10)
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
