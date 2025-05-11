# SoundSlive

🎚️ **SoundSlive** is a native macOS menu bar app built in SwiftUI that lets you control your microphone input volume and (eventually) your active audio sources — like Spotify, Discord, and Chrome.

This was an exploration into CoreAudio, BackgroundMusic, and SwiftUI’s capabilities — and while the UI and mic controls are working great, Apple’s lack of native per-app audio APIs ultimately blocks full functionality on Apple Silicon.

---

## ✅ What Works

- 🎙️ **Mic volume slider and mute toggle**
  - Uses CoreAudio directly to detect the default input device
- 🧼 **Clean and modern SwiftUI menu bar interface**
- 🔌 **Placeholder UI for output sources**
  - Designed to show per-app volume sliders with mute toggles
- ⚙️ **Foundation in place to fetch data from BackgroundMusic API**

---

## ⚠️ What Didn’t Work (Yet)

- ❌ **BackgroundMusic API not responding**
  - Despite installation and permissions, macOS System Integrity Protection (SIP) and recent OS updates seem to block its daemon/helper from running the embedded HTTP API
  - Rebuilding or debugging BackgroundMusic became infeasible without forking and recompiling the entire audio driver stack

- ❌ **No native way to detect or control per-app audio**
  - CoreAudio only exposes per-device controls, not app sessions
  - Apple doesn’t expose APIs equivalent to Windows WASAPI or PulseAudio

---

## 🧠 Lessons Learned

- Working with `CoreAudio` is low-level, undocumented, and often requires workarounds
- BackgroundMusic is clever, but fragile and dependent on internal APIs, unsigned daemons, and virtual drivers that break easily
- SwiftUI is very capable for macOS apps — building polished UI around system audio control is totally feasible

---

## 🚧 Roadmap (Paused for Now)

- [x] Mic volume/mute control
- [x] SwiftUI menu bar app
- [x] Audio source view model with real app names
- [ ] BackgroundMusic API support (broken)
- [ ] Per-app volume + mute control
- [ ] Display of app icons
- [ ] Audio routing via HAL plugin (future)

---

## 📎 Requirements

- macOS 12+ (tested on Apple Silicon)
- Xcode 14+
- BackgroundMusic (if re-enabled)

---

## 🛑 Why We Paused the Project

Due to the lack of native macOS APIs for monitoring or controlling individual app audio streams, and recurring issues with BackgroundMusic’s stability on newer macOS versions (especially with SIP and Gatekeeper restrictions), we’ve decided to pause SoundSlive development until:

- Apple opens up audio session APIs
- A more stable virtual driver emerges
- Or we build a minimal custom plugin

---

## 📖 License

MIT — go nuts.

---
