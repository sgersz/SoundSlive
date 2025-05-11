import SwiftUI

@main
struct SoundSliveApp: App {
    var body: some Scene {
        MenuBarExtra("SoundSlive", systemImage: "waveform.circle.fill") {
            AudioMenuView()
        }
        .menuBarExtraStyle(.window)
    }
}
