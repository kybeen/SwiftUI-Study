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
            HStack {
                Text("감지된 동작: ")
                Text("\(activityClassifier.classLabel)").foregroundColor(activityClassifier.classLabel=="Forehand" ? .cyan : (activityClassifier.classLabel=="Backhand" ? .yellow : .gray))
            }
            HStack {
                Text("Result: ")
                Text(activityClassifier.resultLabel)
                    .foregroundColor(activityClassifier.resultLabel == "Perfect" ? .green : (activityClassifier.resultLabel == "Bad" ? .red : .gray))
            }
            Text("Confidence: \(String(activityClassifier.confidence.prefix(5)))")
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
                Text("\(String(activityClassifier.classLabel.prefix(4)))").font(.body).foregroundColor(activityClassifier.classLabel=="Forehand" ? .cyan : (activityClassifier.classLabel=="Backhand" ? .yellow : .gray))
                Spacer()
                VStack {
                    Text("Perfect").bold()
                    if activityClassifier.classLabel == "Forehand" {
                        Text("\(activityClassifier.forehandPerfectCount)")
                    } else if activityClassifier.classLabel == "Backhand" {
                        Text("\(activityClassifier.backhandPerfectCount)")
                    }
                }.foregroundColor(.green)
                Spacer()
                VStack {
                    Text("Bad").bold()
                    if activityClassifier.classLabel == "Forehand" {
                        Text("\(activityClassifier.forehandBadCount)")
                    } else if activityClassifier.classLabel == "Backhand" {
                        Text("\(activityClassifier.backhandBadCount)")
                    }
                }.foregroundColor(.red)
            }
            .padding()
            
            if activityClassifier.isSwinging {
                Text("스윙 감지!!!").italic().foregroundColor(.mint)
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
