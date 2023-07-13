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
            Text("Class: \(activityClassifier.classLabel)")
            Text("Confidence: \(activityClassifier.confidence)")
            Button("Start Detecting") {
                activityClassifier.startTracking()
            }
            Button("Stop Detecting") {
                activityClassifier.stopTracking()
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
