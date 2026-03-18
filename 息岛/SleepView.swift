import SwiftUI

import Combine

struct SleepView: View {
    @StateObject private var audioManager = AudioManager.shared
    @State private var selectedScene: SleepScene? = nil
    @State private var showTimerSheet = false
    @State private var selectedDuration: TimerDuration? = nil
    @State private var remainingSeconds: Int = 0
    @State private var timerActive = false
    @State private var timer: Timer? = nil
    
    let timerOptions = [
        TimerDuration(title: "片刻宁静", minutes: 1),
        TimerDuration(title: "短暂休憩", minutes: 3),
        TimerDuration(title: "小憩时光", minutes: 5),
        TimerDuration(title: "沉浸冥想", minutes: 15),
        TimerDuration(title: "安然入眠", minutes: 30),
        TimerDuration(title: "整夜安眠", minutes: 60)
    ]
    
    let scenes = [
        SleepScene(
            id: "rain",
            title: "雨声",
            subtitle: "轻柔的雨滴敲打窗檐",
            icon: "cloud.rain.fill",
            color: Color(red: 0.4, green: 0.5, blue: 0.6)
        ),
        SleepScene(
            id: "ocean",
            title: "海浪",
            subtitle: "温柔的海浪拍打沙滩",
            icon: "water.waves",
            color: Color(red: 0.3, green: 0.5, blue: 0.6)
        ),
        SleepScene(
            id: "fire",
            title: "篝火",
            subtitle: "温暖的火焰噼啪作响",
            icon: "flame.fill",
            color: Color(red: 0.7, green: 0.4, blue: 0.3)
        ),
        SleepScene(
            id: "forest",
            title: "森林",
            subtitle: "鸟鸣与微风穿过树叶",
            icon: "leaf.fill",
            color: Color(red: 0.3, green: 0.5, blue: 0.4)
        ),
        SleepScene(
            id: "universe",
            title: "宇宙",
            subtitle: "深邃星空的宁静回响",
            icon: "sparkles",
            color: Color(red: 0.4, green: 0.3, blue: 0.5)
        )
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.98, green: 0.98, blue: 0.99)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("睡眠场景")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("选择一个白噪音场景放松身心")
                                .font(.system(size: 16))
                                .foregroundColor(.black.opacity(0.4))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        
                        if timerActive {
                            WaveTimerCard(
                                duration: selectedDuration,
                                remainingSeconds: remainingSeconds,
                                onStop: { stopAudio() }
                            )
                            .padding(.horizontal, 24)
                            .padding(.bottom, 24)
                            .transition(.opacity)
                        } else {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 8) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 14))
                                        .foregroundColor(.black.opacity(0.4))
                                    
                                    Text("白噪音的益处")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.black.opacity(0.6))
                                }
                                
                                Text("白噪音能屏蔽环境干扰，帮助大脑放松，提升睡眠质量。")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black.opacity(0.5))
                                    .lineSpacing(4)
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(red: 0.96, green: 0.97, blue: 0.98))
                            )
                            .padding(.horizontal, 24)
                            .padding(.bottom, 24)
                            .transition(.opacity)
                        }
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(scenes) { scene in
                                SleepSceneCard(
                                    scene: scene,
                                    isSelected: audioManager.currentScene == scene.id
                                ) {
                                    if audioManager.currentScene == scene.id {
                                        stopAudio()
                                    } else {
                                        selectedScene = scene
                                        showTimerSheet = true
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                            .frame(height: 120)
                    }
                }
            }
            .sheet(isPresented: $showTimerSheet) {
                TimerSelectionSheet(
                    options: timerOptions,
                    onSelect: { duration in
                        startAudio(with: duration)
                        showTimerSheet = false
                    },
                    onSelectForever: {
                        startAudioForever()
                        showTimerSheet = false
                    }
                )
                .presentationDetents([.height(480)])
                .presentationDragIndicator(.hidden)
            }
        }
    }
    
    func startAudio(with duration: TimerDuration) {
        guard let scene = selectedScene else { return }
        
        timer?.invalidate()
        
        audioManager.play(scene: scene.id)
        selectedDuration = duration
        remainingSeconds = duration.minutes * 60
        timerActive = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            DispatchQueue.main.async {
                if self.remainingSeconds > 0 {
                    self.remainingSeconds -= 1
                }
                
                if self.remainingSeconds <= 0 {
                    self.stopAudio()
                }
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func startAudioForever() {
        guard let scene = selectedScene else { return }
        
        timer?.invalidate()
        
        audioManager.play(scene: scene.id)
        selectedDuration = nil
        remainingSeconds = 0
        timerActive = true
    }
    
    func stopAudio() {
        timer?.invalidate()
        timer = nil
        audioManager.stop()
        timerActive = false
        selectedDuration = nil
        remainingSeconds = 0
    }
}

