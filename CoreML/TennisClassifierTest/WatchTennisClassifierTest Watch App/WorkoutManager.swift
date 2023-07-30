//
//  WorkoutManager.swift
//  WatchTennisClassifierTest Watch App
//
//  Created by 김영빈 on 2023/07/27.
//

import Foundation
import HealthKit
import SwiftUI

class WorkoutManager: NSObject, ObservableObject {
    @StateObject var activityClassifier = ActivityClassifier.shared
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    //MARK: Workout 시작
    func startWorkout(workoutType: HKWorkoutActivityType) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor
        
        // Workout Session 생성
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
            print("세선 생성 완료")
        } catch {
            return
        }
        
        builder?.dataSource = HKLiveWorkoutDataSource(
            healthStore: healthStore,
            workoutConfiguration: configuration
        )
        
        // WorkoutManager를 델리게이트로 지정
        session?.delegate = self
        builder?.delegate = self
        
        // Workout session 시작 + 데이터 수집 시작
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            // The workout has started
            print("Workout session 시작!!!")
        }
        activityClassifier.startTracking() // Device Motion 감지 시작
    }
    
    //MARK: HealthKit 권한 요청 함수
    func requestAuthorization() {
        let typesToShare: Set = [HKQuantityType.workoutType()]
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.activitySummaryType() // 액티비티링 summary를 읽을 권한
        ]
        
        // 위에서 정의한 quantity 타입들에 대해 권한 요청
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            if error != nil {
                print("권한 요청 오류: \(error?.localizedDescription)")
            } else {
                if success {
                    print("권한이 허락되었습니다.")
                } else {
                    print("권한이 아직 없어요.")
                }
            }
            for type in typesToShare {
                print("\(type)권한 상태 확인 -> Share: \(self.healthStore.authorizationStatus(for: type))")
            }
            for type in typesToRead {
                print("\(type)권한 상태 확인 -> Share: \(self.healthStore.authorizationStatus(for: type))")
            }
        }
    }
    
    //MARK: - State Control
    // workout 세션의 상태에 따른 일시정지, 재개, 종료 처리
    @Published var running = false
    
    func pause() {
        session?.pause()
        activityClassifier.stopTracking()
    }
    func resume() {
        session?.resume()
        activityClassifier.startTracking()
    }
    func togglePause() {
        if running == true {
            pause()
        } else {
            resume()
        }
    }
    func endWorkout() {
        activityClassifier.stopTracking()
        session?.end()
        print("세션 종료 \(session?.state.rawValue)")
    }
    
    //MARK: - Workout Metrics
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var workout: HKWorkout?
    
    //MARK: Workout 세션 진행 중 값 업데이트 해주는 함수
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        
        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate): // 심박수
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute()) // 분 단위 심박수 받기
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            default:
                return
            }
        }
    }
    
    //MARK: 운동 세션 종료 시 Workout 정보 초기화 함수
    func resetWorkout() {
        builder = nil
        session = nil
        workout = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
    }
}

//MARK: - HKWorkoutSessionDelegate
// Workout 세션 도중 이벤트 처리 관련 델리게이트 메서드
extension WorkoutManager: HKWorkoutSessionDelegate {
    // workout 세션의 state가 변할 때 호출되는 메서드
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        // running 변수는 toState값이 running인지 여부에 따라 업데이트 되며, UI 업데이트를 위해 메인 큐로 발송됩니다.
        DispatchQueue.main.async {
            self.running = toState == .running
        }
        
        if toState == .ended {
            builder?.endCollection(withEnd: date) { (success, error) in // 세션이 종료되면 workout 샘플 수집을 멈춤
                self.builder?.finishWorkout { (workout, error) in
                    DispatchQueue.main.async {
                        self.workout = workout // 운동 종료 시 workout 데이터 저장 (UI 업데이트를 위해 메인 큐에 할당)
                        print("workout 저장: \(workout) -> \(self.workout)")
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
            guard let quantityType = type as? HKQuantityType else { return }
            
            let statistics = workoutBuilder.statistics(for: quantityType)
            
            // @Published 값들 업데이트
            updateForStatistics(statistics)
        }
    }
}
