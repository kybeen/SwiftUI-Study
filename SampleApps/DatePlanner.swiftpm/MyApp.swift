import SwiftUI

@main
struct MyApp: App {
    @StateObject private var eventData = EventData()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                Text("Select an Event")
                    .foregroundStyle(.secondary)
            }
            .environmentObject(eventData)
            // eventData를 전체 뷰 계충에서 사용 가능하도록 하려면 .environmentObject 모디파이어를 사용해주고, 인자로 eventData를 넘겨준다. (이렇게하면 자식 뷰들도 모두 사용 가능)
        }
    }
}
