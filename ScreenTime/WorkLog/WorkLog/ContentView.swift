//
//  ContentView.swift
//  Worklog
//
//  Created by 김영빈 on 2023/04/26.
//

/*
 - FamilyControls 프레임워크에는 작업을 위한 SwiftUI 요소인 familyActivityPicker가 있다.
 - 기본 앱의 UI에서 이 피커를 표시하고, 앱 or 웹을 카테고리 목록에서 선택한다.
 - 버튼을 통해 불러온 피커는 반환값을 모델의 속성에 바인딩한다.($model.selectionToDiscourage)
   - selection에 지정된 모델의 선택 값 프로퍼티는 피커로 선택한 값이 변경될 때마다 갱신됨
 - 앱을 선택한 뒤에는 familyActivityPicker에서 반환된 토큰을 사용할 수 있음.
   - 이 토큰은 각각의 앱과 웹사이트 등을 나타내며, 토큰을 통해 해당하는 앱 등에 제한을 적용해준다.
*/
import DeviceActivity
import SwiftUI
import FamilyControls
import ManagedSettings

extension DeviceActivityReport.Context {
    static let totalActivity = Self("Total Activity")
}

struct ContentView: View {
    //@ObservedObject var store: MyModel
    
    @State var isDiscouragedPresented = false
    //@State private var isEncouragedPresented = false
    
    @State var isReportShowing = false
    // DeviceActivityReportExtension을 추가하여 커스텀했던 view를 식별하기 위해 사용됨
    @State private var context: DeviceActivityReport.Context = .totalActivity
    // DeviceActivityReportExtension에서 makeConfiguration() 메서드 안에 받아오는 데이터(DeviceActivityResults)를 필터링 해주기 위해 사용됨
    @State private var filter = DeviceActivityFilter(
        segment: .daily(
            during: Calendar.current.dateInterval(
                of: .weekOfYear, for: .now
            )!
        ),
        users: .all,
        devices: .init([.iPhone, .iPad]),
        applications: MyModel.shared.selectedApps.applicationTokens,
        categories: MyModel.shared.selectedApps.categoryTokens
    )
    
    var body: some View {
        VStack {
            VStack {
    //            Button {
    //                isReportShowing = true
    //            } label: {
    //                Text("Report")
    //            }
                Text("연장 횟수: \(MyModel.shared.additionalCount.description)")
                Text("isEndPoint: \(MyModel.shared.isEndPoint.description)")
                
                Spacer()
                VStack {
                    // 스크린 타임 권한 요청
                    Button {
                        requestScreenTimePermission()
                    } label: {
                        Text("Request Screen Time Authorization")
                    }

                    // 노티피케이션 권한 요천
                    Button {
                        NotificationManager.shared.requestAuthorization()
                    } label: {
                        Text("Request Notification Authorization")
                    }
                }
                .padding()

    //            // 실드 리셋
    //            Button {
    //                handleResetSelection()
    //            } label: {
    //                Text("Reset shielded apps")
    //            }
                
                Spacer()
                
                Button("Select Apps to Discourage") {
                    isDiscouragedPresented = true
                }
                .familyActivityPicker(headerText: "FamilyActivityPicker 헤더명", isPresented: $isDiscouragedPresented, selection: MyModel.shared.$selectedApps)
                .padding()
                .foregroundColor(.gray)
                
                if let firstToken = MyModel.shared.selectedApps.applicationTokens.first {
                    Label(firstToken)
                        .frame(maxWidth: .infinity)
                        .labelStyle(.iconOnly)
                } else {
                    Text("선택된 앱이 없습니다.")
                }
    //            Button("Select Apps to Encourage") {
    //                isEncouragedPresented = true
    //            }
    //            .familyActivityPicker(isPresented: $isEncouragedPresented, selection: $model.selectionToEncourage)
                Spacer()
                
                // 데일리 테스트 시작 버튼
                Button {
                    handleStartDeviceActivityMonitoring()
                } label: {
                    ZStack {
                        Color.orange
                        Text("Daily test Monitoring start")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                    .frame(width: UIScreen.main.bounds.width*0.8, height: 50)
                    .cornerRadius(15)
                }
                // 데일리 수면 시작 버튼
                Button {
                    setDailySleepSchedule()
                } label: {
                    ZStack {
                        Color.orange
                        Text("Daily Sleep Monitoring start")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                    .frame(width: UIScreen.main.bounds.width*0.8, height: 50)
                    .cornerRadius(15)
                }
            }

                Button {
                    //MyModel.shared.setAdditionalFifteenSchedule()
                    print("Activitiies: \(MyModel.shared.deviceActivityCenter.activities)")
                    if MyModel.shared.deviceActivityCenter.schedule(for: .test) != nil {
                        print("Schedule .test: \(MyModel.shared.deviceActivityCenter.schedule(for: .test))\n")
                    }
                    if MyModel.shared.deviceActivityCenter.schedule(for: .dailySleep) != nil {
                        print("Schedule .dailySleep: \(MyModel.shared.deviceActivityCenter.schedule(for: .dailySleep))\n")
                    }
//                    if MyModel.shared.deviceActivityCenter.schedule(for: .additionalFifteenOne) != nil {
//                        print("Schedule .additionalFifteenOne: \(MyModel.shared.deviceActivityCenter.schedule(for: .additionalFifteenOne))\n")
//                    }
//                    if MyModel.shared.deviceActivityCenter.schedule(for: .additionalFifteenTwo) != nil {
//                        print("Schedule .additionalFifteenTwo: \(MyModel.shared.deviceActivityCenter.schedule(for: .additionalFifteenTwo))\n")
//                    }
                    if MyModel.shared.deviceActivityCenter.schedule(for: .additionalFifteen) != nil {
                        print("Schedule .additionalFifteen: \(MyModel.shared.deviceActivityCenter.schedule(for: .additionalFifteen))\n")
                    }
                    print("additionalCount: \(MyModel.shared.additionalCount)")
                    print("isEndPoint: \(MyModel.shared.isEndPoint.description)\n\n")
                    
                } label: {
                    Text("액티비티 조회")
                }
        }
        .padding()
        .sheet(isPresented: $isReportShowing) {
            // DeviceActivityReport 생성
            DeviceActivityReport(context, filter: filter) // 필터를 지정하지 않을 경우에는 현재 사용자와 현재 기기에 대한 모든 device activity 데이터를 device activity report app extension에 제공함
                .frame(
                    width: UIScreen.main.bounds.width*0.8,
                    height: UIScreen.main.bounds.height*0.6
                )
                .background(.gray)
        }
    }
}

extension ContentView {
    //MARK: 스크린타임 권한 요청
    private func requestScreenTimePermission() {
        let center = AuthorizationCenter.shared
        
        if center.authorizationStatus == .approved {
            print("ScreenTime Permission approved")
        } else {
            print("Request ScreenTime Permission...")
            Task {
                do {
                    try await center.requestAuthorization(for: .individual)
                    print("Approved Status: \(AuthorizationStatus.approved)")
                } catch {
                    print("Failed to enroll User with error: \(error)")
                }
            }
        }
    }
    
//    //MARK: 노티피케이션 권한 요청
//    private func requestNotificationPermission() {
//        let center = UNUserNotificationCenter.current()
//
//        center.getNotificationSettings { settings in
//            switch settings.alertSetting {
//            case .enabled:
//                print("Notification Permission approved!!")
//            default:
//                print("Notification Permission NOT approved")
//
//            Task {
//                do {
//                    try await center.requestAuthorization(options: [.alert, .badge, .sound])
//                } catch {
//                    print("Failed to enroll Aniyah with error: \(error)")
//                }
//
//            }
//            }
//        }
//    }
    
    //MARK: 현재 선택된 앱 초기화
    private func handleResetSelection() {
        MyModel.shared.handleResetSelection()
        handleStartDeviceActivityMonitoring(includeUsageThreshold: false)
    }
    
    //MARK: 앱 제한 모니터링 등록 및 시작
    private func handleStartDeviceActivityMonitoring(includeUsageThreshold: Bool = true) {
        MyModel.shared.handleStartDeviceActivityMonitoring(includeUsageThreshold: includeUsageThreshold)
    }
    
    private func handleSetBlockApplication() {
        MyModel.shared.handleSetBlockApplication()
    }
    
    //MARK: 데일리 수면 모니터링 등록 및 시작
    private func setDailySleepSchedule() {
        MyModel.shared.setDailySleepSchedule()
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(store: MyModel.shared)
//    }
//}
