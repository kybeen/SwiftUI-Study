//
//  MetricsView.swift
//  HealthKitTest Watch App
//
//  Created by 김영빈 on 2023/07/27.
//

import SwiftUI

struct MetricsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(),
                                             isPaused: workoutManager.session?.state == .paused)) { context in
            VStack(alignment: .leading) {
                // subseconds를 보여줄지 말지는 context의 cadence값에 따라 결정된다.
                ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0, showSubseconds: context.cadence == .live)
                    .foregroundStyle(.yellow)
                Text(Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
                        .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number.precision(.fractionLength(0)))))
                Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
                Text(Measurement(value: workoutManager.distance, unit: UnitLength.meters).formatted(.measurement(width: .abbreviated, usage: .road)))
            }
            .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
            .frame(maxWidth: .infinity, alignment: .leading)
            .ignoresSafeArea(edges: .bottom)
            .scenePadding()
        }
//        TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date())
//        ) { context in
//            VStack(alignment: .leading) {
//                ElapsedTimeView(
//                    elapsedTime: workoutManager.builder?.elapsedTime ?? 0,
//                    showSubseconds: context.cadence == .live // subseconds를 보여줄지 말지는 context의 cadence값에 따라 결정된다.
//                ).foregroundColor(Color.yellow)
//                Text(
//                    formatter.string(
//                        from: Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
//                    )
//                )
//                Text(
//                    workoutManager.heartRate
//                        .formatted(
//                            .number.precision(.fractionLength(0))
//                        )
//                    + " bpm"
//                )
//                Text(
//                    Measurement(
//                        value: workoutManager.distance,
//                        unit: UnitLength.meters
//                    ).formatted(
//                        .measurement(
//                            width: .abbreviated,
//                            usage: .road
//                        )
//                    )
//                )
//            }
//            .font(.system(.title, design: .rounded)
//                    .monospacedDigit()
//                    .lowercaseSmallCaps()
//            )
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .ignoresSafeArea(edges: .bottom)
//            .scenePadding()
//        }
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
            .environmentObject(WorkoutManager())
    }
}

// 활성화된 workout 세션이 있는 앱은 Always On 상태에서 최대 1초에 한 번씩 업데이트가 가능하다.
// 따라서 Always On 상태에서는 시간 표시에 subseconds가 들어가지 않도록 해주어야 한다.
private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date
    var isPaused: Bool

    init(from startDate: Date, isPaused: Bool) {
        self.startDate = startDate
        self.isPaused = isPaused
    }

//    func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries {
//        PeriodicTimelineSchedule(
//            from: self.startDate,
//            by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0)
//        ).entries(
//            from: startDate,
//            mode: mode
//        )
//    }
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> AnyIterator<Date> {
        var baseSchedule = PeriodicTimelineSchedule(from: self.startDate,
                                                    by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0)) // lowFrequency-1초, normal-1초당30번,
            .entries(from: startDate, mode: mode)
        
        return AnyIterator<Date> {
            guard !isPaused else { return nil }
            return baseSchedule.next()
        }
    }
}
