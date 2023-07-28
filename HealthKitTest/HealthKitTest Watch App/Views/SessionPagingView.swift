//
//  SessionPagingView.swift
//  HealthKitTest Watch App
//
//  Created by 김영빈 on 2023/07/27.
//

import SwiftUI
import WatchKit

struct SessionPagingView: View {
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var selection: Tab = .metrics

    // 탭뷰 선택값
    enum Tab {
        case controls, metrics, nowPlaying
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ControlsView().tag(Tab.controls)
            MetricsView().tag(Tab.metrics)
            NowPlayingView().tag(Tab.nowPlaying)
        }
        .navigationTitle(workoutManager.selectedWorkout?.name ?? "")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(selection == .nowPlaying)
        // 일시정지나 다시 시작하면 MetricsView로 다시 전환되도록
        .onChange(of: workoutManager.running) { _ in
            displayMetricsView()
        }
        .tabViewStyle( // Always On 모드가 되면 탭뷰의 페이지 인디케이터를 가림
            PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic)
        )
        .onChange(of: isLuminanceReduced) { _ in // Always On 모드가 되면 MetricsView만 화면에 표시
            displayMetricsView()
        }
    }
    
    // MetricsView로 탭뷰 포커싱해주는 함수
    private func displayMetricsView() {
        withAnimation {
            selection = .metrics
        }
    }
}

struct SessionPagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView()
            .environmentObject(WorkoutManager())
    }
}
