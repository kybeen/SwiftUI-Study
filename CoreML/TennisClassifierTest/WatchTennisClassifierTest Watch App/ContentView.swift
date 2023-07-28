//
//  ContentView.swift
//  WatchTennisClassifierTest Watch App
//
//  Created by 김영빈 on 2023/07/13.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @StateObject var activityClassifier = ActivityClassifier.shared
    
//    // 소모 칼로리에 대한 formatter
//    let formatter = MeasurementFormatter()
//    init() {
//        formatter.numberFormatter.maximumFractionDigits = 0
//    }

    var body: some View {
        TimelineView(
            MetricsTimelineSchedule(
                from: workoutManager.builder?.startDate ?? Date()
            )
        ) { context in
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    ElapsedTimeView(
                        elapsedTime: workoutManager.builder?.elapsedTime ?? 0,
                        showSubseconds: context.cadence == .live
                    ).foregroundColor(.yellow)
                    Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
//                    Text(formatter.string(from: Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)))
                    Text(Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
                            .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number.precision(.fractionLength(0)))))
                }
                .font(.system(.title3, design: .rounded)
                    .monospacedDigit()
                    .lowercaseSmallCaps()
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .ignoresSafeArea(edges: .bottom)
                .scenePadding()
                HStack {
                    Button {
                        workoutManager.startWorkout(workoutType: .walking)
//                        activityClassifier.startTracking()
                    } label: {
                        Image(systemName: "play.fill").foregroundColor(.green)
                    }
                    Button {
                        print("버튼 종료시 elapsed Time : ", workoutManager.builder?.elapsedTime)
                        workoutManager.endWorkout()
//                        activityClassifier.stopTracking()
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
            .onAppear {
                // HealthKit 권한 요청
                workoutManager.requestAuthorization()
            }
        }
        
//        VStack {
////            HStack {
////                Text("감지된 동작: ")
////                Text("\(activityClassifier.classLabel)").foregroundColor(activityClassifier.classLabel=="Forehand" ? .cyan : (activityClassifier.classLabel=="Backhand" ? .yellow : .gray))
////            }
////            HStack {
////                Text("Result: ")
////                Text(activityClassifier.resultLabel)
////                    .foregroundColor(activityClassifier.resultLabel == "Perfect" ? .green : (activityClassifier.resultLabel == "Bad" ? .red : .gray))
////            }
////            Text("Confidence: \(String(activityClassifier.confidence.prefix(5)))")
////            Text("Time: \(activityClassifier.timestamp)")
//            HStack {
//                Button {
//                    workoutManager.startWorkout(workoutType: .tennis)
//                    print("운동 시작!!!!")
////                    activityClassifier.startTracking()
//                } label: {
//                    Image(systemName: "play.fill").foregroundColor(.green)
//                }
//                Button {
//                    activityClassifier.stopTracking()
//                    print("운동 종료!!!!")
////                    workoutManager.endWorkout()
//                } label: {
//                    Image(systemName: "stop.fill").foregroundColor(.red)
//                }
//            }
//
////            HStack {
////                Text("\(String(activityClassifier.classLabel.prefix(4)))").font(.body).foregroundColor(activityClassifier.classLabel=="Forehand" ? .cyan : (activityClassifier.classLabel=="Backhand" ? .yellow : .gray))
////                Spacer()
////                VStack {
////                    Text("Perfect").bold()
////                    if activityClassifier.classLabel == "Forehand" {
////                        Text("\(activityClassifier.forehandPerfectCount)")
////                    } else if activityClassifier.classLabel == "Backhand" {
////                        Text("\(activityClassifier.backhandPerfectCount)")
////                    }
////                }.foregroundColor(.green)
////                Spacer()
////                VStack {
////                    Text("Bad").bold()
////                    if activityClassifier.classLabel == "Forehand" {
////                        Text("\(activityClassifier.forehandBadCount)")
////                    } else if activityClassifier.classLabel == "Backhand" {
////                        Text("\(activityClassifier.backhandBadCount)")
////                    }
////                }.foregroundColor(.red)
////            }
////            .padding()
////
////            if activityClassifier.isSwinging {
////                Text("스윙 감지!!!").italic().foregroundColor(.mint)
////            }
//            VStack {
//                Text("평균 심박수: \(workoutManager.averageHeartRate)")
//                Text("심박수: \(workoutManager.heartRate)")
//                Text("칼로리: \(formatter.string(from: Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)))")
//            }
//        }
//        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(WorkoutManager())
    }
}

// Always On 상태에서는 시간 표시에 subseconds가 들어가지 않도록 해줌
private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date

    init(from startDate: Date) {
        self.startDate = startDate
    }

    func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(
            from: self.startDate,
            by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0) // lowFrequency-1초, normal-1초당30번,
        ).entries(
            from: startDate,
            mode: mode
        )
    }
}
