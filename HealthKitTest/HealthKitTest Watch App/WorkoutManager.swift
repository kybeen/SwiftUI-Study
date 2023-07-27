//
//  WorkoutManager.swift
//  HealthKitTest Watch App
//
//  Created by 김영빈 on 2023/07/27.
//

import Foundation
import HealthKit

class WorkoutManager: NSObject, ObservableObject {
    var selectedWorkout: HKWorkoutActivityType? {
        // selectedWorkout 값이 바뀔 때마다 해당 workout 활동에 대한 startWorkout 함수가 호출되도록 함
        didSet {
            // guard let 구문을 사용해서 selectedWorkout 값이 nil이 아닐 때만 실행되도록 해줌
            guard let selectedWorkout = selectedWorkout else { return }
            startWorkout(workoutType: selectedWorkout)
        }
    }
    
    @Published var showingSummaryView: Bool = false {
        didSet {
            // Sheet dismissed
            if showingSummaryView == false {
                resetWorkout()
            }
        }
    }
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    func startWorkout(workoutType: HKWorkoutActivityType) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor
        
        // Workout Session 생성
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            // Handle any exceptions.
            return
        }
        
        builder?.dataSource = HKLiveWorkoutDataSource(
            healthStore: healthStore,
            workoutConfiguration: configuration
        )
        
        // WorkoutManager를 델리게이트로 지정
        session?.delegate = self
        builder?.delegate = self // builder에 의해 추가되는 workout 샘플을 관찰하려면 WorkoutManager가 builder의 델리게이트로 지정되어 있어야 한다.
        
        // Start the workout session and begin data collection.
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            // The workout has started.
        }
    }
    
    // Request authorization to access HealthKit (HealthKit에 접근하기 위한 권한 요청)
    func requestAuthorization() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]
        
        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKObjectType.activitySummaryType() // 액티비티링 summary를 읽을 권한
        ]
        
        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
        }
    }
    
    //MARK: - State Control
    // workout 세션의 상태에 따른 일시정지, 재개, 종료 처리
    
    // The workout session state.
    @Published var running = false
    
    func pause() {
        session?.pause()
    }
    
    func resume() {
        session?.resume()
    }
    
    func togglePause() {
        if running == true {
            pause()
        } else {
            resume()
        }
    }
    
    func endWorkout() {
        session?.end()
        showingSummaryView = true
    }
    
    //MARK: - Workout Metrics
    @Published var averageHeartRate: Double = 0 // SummaryView에서 사용
    // MetricsView에서 사용
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    @Published var workout: HKWorkout?
    
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }

        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute()) // 분 단위 심박수를 얻기 위해 분 단위로 유닛을 쪼갬
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie() // 열량 에너지 소모는 킬로칼로리 단위 사용
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning), HKQuantityType.quantityType(forIdentifier: .distanceCycling):
                // 걷기, 달리기, 자전거의 경우 거리 단위로 미터 사용
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            default:
                return
            }
        }
    }
    
    // SummaryView를 닫으면 모델의 모든 값들을 초기화
    func resetWorkout() {
        selectedWorkout = nil
        builder = nil
        session = nil
        workout = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
    }
}

//MARK: - HKWorkoutSessionDelegate
// 이벤트 처리 델리게이트 메서드
extension WorkoutManager: HKWorkoutSessionDelegate {
    // wowrkout 세션의 state가 변할 때 호출되는 메서드
    func workoutSession(_ workoutSession: HKWorkoutSession,
                        didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState,
                        date: Date) {
        // running 변수는 toState값이 running인지 여부에 따라 업데이트되며, UI 업데이트를 위해 메인 큐로 발송됩니다.
        DispatchQueue.main.async {
            self.running = toState == .running
        }
        
        // Wait for the session to transition states before ending the builder.
        // 세션이 종료되면 workout 샘플 수집을 멈춘다. (endCollection)
        // 그 후 HKWorkout을 Health database에 저장한다. (finishWorkout)
        // -> WorkoutManager가 HKWorkoutSession 델리게이트로 할당되어 있어야 함
        if toState == .ended {
            builder?.endCollection(withEnd: date) { (success, error) in
                self.builder?.finishWorkout { (workout, error) in
                    DispatchQueue.main.async {
                        self.workout = workout // 운동 종료 시 workout 데이터 저장 (UI 업데이트를 위해 메인 큐에 할당)
                    }
                }
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
}

//MARK: - HKLiveWorkoutBuilderDelegate
// workout 데이터 추적 델리게이트
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    // builder가 이벤트를 수집할 때마다 호출되는 메서드
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
    }
    
    // builder가 새로운 샘플을 수집할 때마다 호출되는 메서드
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes { // 수집된 샘플의 타입이 HKQuantityType 타입인지 확인
            guard let quantityType = type as?  HKQuantityType else { return }
            
            let statistics = workoutBuilder.statistics(for: quantityType)
            
            // Update the published values.
            updateForStatistics(statistics)
        }
    }
}
