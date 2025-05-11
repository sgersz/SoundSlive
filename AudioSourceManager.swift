//
//  AudioSourceManager.swift
//  SoundSlive
//
//  Created by Steve Gersztyn on 5/11/25.
//

import Foundation

struct RunningAudioApp: Identifiable, Decodable {
    let pid: Int
    let bundleId: String
    let name: String
    let volume: Double
    let muted: Bool

    var id: Int { pid }
}

class AudioSourceManager: ObservableObject {
    @Published var apps: [RunningAudioApp] = []

    func fetchApps() {
        guard let url = URL(string: "http://localhost:5959/api/v1/apps") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                let decoded = try? JSONDecoder().decode([RunningAudioApp].self, from: data)
            else {
                print("Failed to fetch or decode audio apps")
                return
            }

            DispatchQueue.main.async {
                self.apps = decoded
            }
        }.resume()
    }
}
