import AVFoundation
import SwiftUI

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    @Published var isPlaying: Bool = false
    @Published var currentScene: String? = nil
    @Published var volume: Float = 0.5
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {
        setupAudioSession()
        setupNotifications()
    }
    
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(
                .playback,
                mode: .default,
                options: [.mixWithOthers]
            )
            try session.setActive(true)
        } catch {
            print("音频会话配置失败: \(error.localizedDescription)")
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioSessionInterruption),
            name: AVAudioSession.interruptionNotification,
            object: nil
        )
    }
    
    @objc private func handleAudioSessionInterruption(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        switch type {
        case .began:
            break
        case .ended:
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    audioPlayer?.play()
                }
            }
        @unknown default:
            break
        }
    }
    
    func play(scene: String) {
        guard let url = Bundle.main.url(forResource: scene, withExtension: "mp3") else {
            print("音频文件未找到: \(scene).mp3")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = volume
            audioPlayer?.play()
            
            isPlaying = true
            currentScene = scene
        } catch {
            print("音频播放失败: \(error.localizedDescription)")
        }
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        currentScene = nil
    }
    
    func setVolume(_ value: Float) {
        volume = value
        audioPlayer?.volume = value
    }
}