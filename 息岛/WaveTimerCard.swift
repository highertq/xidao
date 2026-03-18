import SwiftUI
import Combine

struct WaveTimerCard: View {
    let duration: TimerDuration?
    let remainingSeconds: Int
    let onStop: () -> Void
    
    @State private var wavePhase: CGFloat = 0
    @State private var longPressProgress: CGFloat = 0
    @State private var isPressing = false
    @State private var pressStartTime: Date?
    @State private var progressTimer: Timer?
    @State private var showCelebration = false
    @State private var cardScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.96, green: 0.97, blue: 0.98))
            
            WaveView(phase: wavePhase)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .opacity(0.6)
            
            VStack(spacing: 8) {
                if remainingSeconds > 0 {
                    Text(formatTime(remainingSeconds))
                        .font(.system(size: 32, weight: .light, design: .rounded))
                        .foregroundColor(.black.opacity(0.75))
                } else {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color(red: 0.3, green: 0.7, blue: 0.5))
                            .frame(width: 8, height: 8)
                        
                        Text("播放中")
                            .font(.system(size: 20, weight: .light))
                            .foregroundColor(.black.opacity(0.7))
                    }
                }
            }
            
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    Color.black.opacity(0.08),
                    lineWidth: 1
                )
            
            RoundedRectangle(cornerRadius: 16)
                .trim(from: 0, to: longPressProgress)
                .stroke(
                    Color.black.opacity(0.3),
                    style: StrokeStyle(lineWidth: 2, lineCap: .round)
                )
            
            // 庆祝特效叠加层
            if showCelebration {
                ZStack {
                    // 半透明遮罩
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.85))
                    
                    // 庆祝内容
                    VStack(spacing: 8) {
                        Text("✨")
                            .font(.system(size: 26))
                        
                        Text("身体修复完成")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color(red: 0.3, green: 0.55, blue: 0.5))
                    }
                    .transition(.scale.combined(with: .opacity))
                }
                .transition(.opacity)
            }
            
            // 撒花粒子
            if showCelebration {
                CelebrationParticlesView()
            }
        }
        .frame(height: 100)
        .scaleEffect(cardScale)
        .contentShape(RoundedRectangle(cornerRadius: 16))
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressing {
                        isPressing = true
                        startProgressAnimation()
                    }
                }
                .onEnded { _ in
                    isPressing = false
                    stopProgressAnimation()
                }
        )
        .onAppear {
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                wavePhase = 1
            }
        }
    }
    
    func startProgressAnimation() {
        longPressProgress = 0
        pressStartTime = Date()
        
        progressTimer?.invalidate()
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            guard let startTime = pressStartTime else { return }
            let elapsed = Date().timeIntervalSince(startTime)
            let progress = min(elapsed / 2.0, 1.0)
            
            DispatchQueue.main.async {
                longPressProgress = progress
                
                if progress >= 1.0 && isPressing {
                    triggerCelebration()
                }
            }
        }
    }
    
    func stopProgressAnimation() {
        progressTimer?.invalidate()
        progressTimer = nil
        pressStartTime = nil
        
        if longPressProgress >= 1.0 {
        } else {
            withAnimation(.easeOut(duration: 0.3)) {
                longPressProgress = 0
            }
        }
    }
    
    func triggerCelebration() {
        progressTimer?.invalidate()
        progressTimer = nil
        
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            showCelebration = true
            cardScale = 1.05
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            onStop()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeOut(duration: 0.3)) {
                    showCelebration = false
                    cardScale = 1.0
                    longPressProgress = 0
                }
            }
        }
    }
    
    func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", mins, secs)
    }
}

struct CelebrationParticlesView: View {
    @State private var particles: [CelebrationParticle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                CelebrationParticleView(particle: particle)
            }
        }
        .onAppear {
            generateParticles()
        }
    }
    
    func generateParticles() {
        let colors: [Color] = [
            Color(red: 0.9, green: 0.7, blue: 0.8),
            Color(red: 0.7, green: 0.8, blue: 0.9),
            Color(red: 0.8, green: 0.9, blue: 0.7),
            Color(red: 0.9, green: 0.85, blue: 0.7),
            Color(red: 0.85, green: 0.75, blue: 0.9)
        ]
        
        for i in 0..<12 {
            let angle = Double(i) * (360.0 / 12.0) * .pi / 180.0
            let distance = CGFloat.random(in: 50...90)
            let particle = CelebrationParticle(
                id: i,
                color: colors[i % colors.count],
                angle: angle,
                distance: distance,
                size: CGFloat.random(in: 5...9),
                delay: Double.random(in: 0...0.1)
            )
            particles.append(particle)
        }
    }
}

struct CelebrationParticle: Identifiable {
    let id: Int
    let color: Color
    let angle: Double
    let distance: CGFloat
    let size: CGFloat
    let delay: Double
}

struct CelebrationParticleView: View {
    let particle: CelebrationParticle
    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0
    
    var body: some View {
        Circle()
            .fill(particle.color)
            .frame(width: particle.size, height: particle.size)
            .offset(offset)
            .opacity(opacity)
            .scaleEffect(scale)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + particle.delay) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        let x = CGFloat(cos(particle.angle)) * particle.distance
                        let y = CGFloat(sin(particle.angle)) * particle.distance
                        offset = CGSize(width: x, height: y)
                        opacity = 1
                        scale = 1
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation(.easeIn(duration: 0.3)) {
                            opacity = 0
                            scale = 0.5
                        }
                    }
                }
            }
    }
}