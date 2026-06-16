import SwiftUI
import WidgetKit

@main
struct CDMWidgetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.recommended)
    }
}
