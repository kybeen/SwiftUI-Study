//
//  ContentView.swift
//  WatchTennisClassifierTest Watch App
//
//  Created by 김영빈 on 2023/07/13.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var activityClassifier = ActivityClassifier()

    var body: some View {
        VStack {
            Text("감지된 동작 (\(activityClassifier.classLabel))")
            Text("Result: \(activityClassifier.resultLabel)")
            Text("Confidence: \(activityClassifier.confidence)")
            Text("Time: \(activityClassifier.timestamp)")
            HStack {
                Button {
                    activityClassifier.startTracking()
                } label: {
                    Image(systemName: "play.fill").foregroundColor(.green)
                }
                Button {
                    activityClassifier.stopTracking()
                } label: {
                    Image(systemName: "stop.fill").foregroundColor(.red)
                }
            }
            
            HStack {
                Spacer()
                VStack {
                    Text("Perfect").bold()
                    Text("\(activityClassifier.perfectCount)")
                }.foregroundColor(.green)
                Spacer()
                VStack {
                    Text("Bad").bold()
                    Text("\(activityClassifier.badCount)")
                }.foregroundColor(.red)
                Spacer()
            }
            .padding()
            
            if activityClassifier.isSwinging {
                Text("스윙 감지!!!").italic().foregroundColor(.cyan)
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
