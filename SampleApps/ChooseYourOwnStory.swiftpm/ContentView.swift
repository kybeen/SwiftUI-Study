import SwiftUI

@available(iOS 16.0, *)
struct ContentView: View {
    var body: some View {
        NavigationStack {
            StoryPageView(story: story, pageIndex: 0)
        }
    }
}
