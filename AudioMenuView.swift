import SwiftUI
import CoreAudio
import CoreAudioTypes

struct AudioMenuView: View {
    @StateObject var manager = AudioSourceManager()

    @State private var micVolume: Double = getMicVolume()
    @State private var micMuted: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 🎙️ Microphone section
            Text("Microphone")
                .font(.headline)

            HStack {
                Slider(value: Binding(
                    get: { micVolume },
                    set: {
                        micVolume = $0
                        setMicVolume($0)
                        micMuted = $0 == 0
                    }
                ), in: 0...1)

                Toggle("Mute", isOn: Binding(
                    get: { micMuted },
                    set: {
                        micMuted = $0
                        setMicVolume($0 ? 0 : micVolume == 0 ? 0.5 : micVolume)
                    }
                ))
                .labelsHidden()
            }

            Divider()

            // 🔊 Output audio sources section
            Text("Output Sources")
                .font(.headline)

            ForEach(manager.apps) { app in
                VStack(alignment: .leading) {
                    HStack {
                        Text(app.name)
                        Spacer()
                        Toggle("Mute", isOn: .constant(app.muted))
                            .labelsHidden()
                            .disabled(true)
                    }
                    Slider(value: .constant(app.volume), in: 0...1)
                        .disabled(true)
                }
            }
        }
        .padding()
        .frame(width: 260)
        .onAppear {
            manager.fetchApps()
        }
    }
}

// MARK: - Microphone Volume Helpers

func getMicVolume() -> Double {
    var deviceID = getDefaultInputDevice()
    var volume = Float32(0)
    var size = UInt32(MemoryLayout<Float32>.size)
    var address = AudioObjectPropertyAddress(
        mSelector: kAudioDevicePropertyVolumeScalar,
        mScope: kAudioDevicePropertyScopeInput,
        mElement: kAudioObjectPropertyElementMaster
    )

    let status = AudioObjectGetPropertyData(deviceID, &address, 0, nil, &size, &volume)
    return status == noErr ? Double(volume) : 0.5
}

func setMicVolume(_ newValue: Double) {
    var deviceID = getDefaultInputDevice()
    var volume = Float32(newValue)
    let size = UInt32(MemoryLayout<Float32>.size)
    var address = AudioObjectPropertyAddress(
        mSelector: kAudioDevicePropertyVolumeScalar,
        mScope: kAudioDevicePropertyScopeInput,
        mElement: kAudioObjectPropertyElementMaster
    )

    AudioObjectSetPropertyData(deviceID, &address, 0, nil, size, &volume)
}

func getDefaultInputDevice() -> AudioDeviceID {
    var deviceID = AudioDeviceID()
    var size = UInt32(MemoryLayout<AudioDeviceID>.size)
    var address = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDefaultInputDevice,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMaster
    )

    AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &size, &deviceID)
    return deviceID
}
