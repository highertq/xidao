import SwiftUI
import Foundation

struct HomeView: View {
    @State private var showMeditation = false
    @State private var selectedEmotion: String = ""
    @State private var showContent = false
    
    let emotions = [
        ("我很累", "moon.zzz.fill", Color(red: 0.6, green: 0.7, blue: 0.85)),
        ("我很焦虑", "wind", Color(red: 0.75, green: 0.8, blue: 0.7)),
        ("我很烦躁", "flame.fill", Color(red: 0.85, green: 0.7, blue: 0.65)),
        ("我睡不着", "moon.stars.fill", Color(red: 0.65, green: 0.7, blue: 0.85)),
        ("我需要专注", "brain.head.profile", Color(red: 0.7, green: 0.75, blue: 0.8))
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 40) {
                        Spacer().frame(height: 60)
                        
                        Text("息岛")
                            .font(.system(size: 36, weight: .light, design: .serif))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.black.opacity(0.7), Color.black.opacity(0.5)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : -20)
                        
                        EnhancedBreathingAnimation()
                            .frame(width: 260, height: 260)
                            .opacity(showContent ? 1 : 0)
                            .scaleEffect(showContent ? 1 : 0.8)
                        
                        Text("此刻，你感觉如何？")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.black.opacity(0.45))
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 10)
                        
                        VStack(spacing: 14) {
                            ForEach(Array(emotions.enumerated()), id: \.element.0) { index, emotion in
                                EnhancedEmotionButton(
                                    title: emotion.0,
                                    icon: emotion.1,
                                    accentColor: emotion.2,
                                    delay: Double(index) * 0.08
                                ) {
                                    selectedEmotion = emotion.0
                                    showMeditation = true
                                }
                            }
                        }
                        .padding(.horizontal, 28)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 30)
                        
                        Spacer().frame(height: 100)
                    }
                }
            }
            .fullScreenCover(isPresented: $showMeditation) {
                MeditationView(emotion: selectedEmotion) {
                    showMeditation = false
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                    showContent = true
                }
            }
        }
    }
}

struct AnimatedBackground: View {
    @State private var phase: CGFloat = 0
    
    private let bgColor1 = Color(red: 0.98, green: 0.985, blue: 0.99)
    private let bgColor2 = Color(red: 0.96, green: 0.975, blue: 0.985)
    private let bgColor3 = Color(red: 0.975, green: 0.98, blue: 0.985)
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [bgColor1, bgColor2, bgColor3],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}

struct EnhancedBreathingAnimation: View {
    @State private var breathPhase: CGFloat = 0
    @State private var rotation: Double = 0
    @State private var tapScale: CGFloat = 1.0
    
    private let outerColor = Color(red: 0.85, green: 0.9, blue: 0.95)
    private let ringColor = Color(red: 0.4, green: 0.5, blue: 0.6)
    private let coreColor1 = Color(red: 0.97, green: 0.98, blue: 0.99)
    private let coreColor2 = Color(red: 0.94, green: 0.96, blue: 0.98)
    private let shadowColor = Color(red: 0.7, green: 0.8, blue: 0.9)
    private let innerRingColor = Color(red: 0.5, green: 0.6, blue: 0.7)
    private let leafColor1 = Color(red: 0.5, green: 0.7, blue: 0.55)
    private let leafColor2 = Color(red: 0.6, green: 0.75, blue: 0.6)
    
    private var sinValue: Double {
        Foundation.sin(Double(breathPhase))
    }
    
    var body: some View {
        ZStack {
            outerGlow
            breathingRings
            coreCircle
            innerRing
            centerIcon
        }
        .scaleEffect(tapScale)
        .onTapGesture {
            playTapFeedback()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                breathPhase = .pi * 2
            }
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
    
    private var outerGlow: some View {
        let opacity = 0.15 + 0.1 * sinValue
        let scale = 1.0 + 0.08 * sinValue
        return Circle()
            .fill(
                RadialGradient(
                    colors: [outerColor.opacity(opacity), Color.clear],
                    center: .center,
                    startRadius: 60,
                    endRadius: 140
                )
            )
            .scaleEffect(scale)
    }
    
    private var breathingRings: some View {
        ForEach(0..<4, id: \.self) { index in
            let delay = CGFloat(index) * 0.4
            let phaseOffset = Double(breathPhase - delay)
            let sinOffset = Foundation.sin(phaseOffset)
            let scale = 1.0 + 0.12 * sinOffset + Double(index) * 0.08
            let opacity = 0.06 + 0.04 * sinOffset - Double(index) * 0.01
            
            Circle()
                .stroke(ringColor.opacity(opacity), lineWidth: 1)
                .frame(width: 160, height: 160)
                .scaleEffect(scale)
        }
    }
    
    private var coreCircle: some View {
        let scale = 0.9 + 0.08 * sinValue
        return Circle()
            .fill(
                RadialGradient(
                    colors: [coreColor1, coreColor2.opacity(0.8), Color.clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: 70
                )
            )
            .frame(width: 140, height: 140)
            .shadow(color: shadowColor.opacity(0.15), radius: 30, x: 0, y: 10)
            .scaleEffect(scale)
    }
    
    private var innerRing: some View {
        let scale = 0.95 + 0.05 * Foundation.cos(Double(breathPhase) * 1.2)
        return Circle()
            .stroke(innerRingColor.opacity(0.12), lineWidth: 0.5)
            .frame(width: 100, height: 100)
            .scaleEffect(scale)
    }
    
    private var centerIcon: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.9), Color(red: 0.96, green: 0.97, blue: 0.98).opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 56, height: 56)
                .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
            
            Image(systemName: "leaf.fill")
                .font(.system(size: 22, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        colors: [leafColor1, leafColor2],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .rotationEffect(.degrees(rotation))
        }
    }
    
    private func playTapFeedback() {
        let impact = UIImpactFeedbackGenerator(style: .soft)
        impact.impactOccurred()
        
        withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
            tapScale = 0.85
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                tapScale = 1.0
            }
        }
    }
}

struct EnhancedEmotionButton: View {
    let title: String
    let icon: String
    let accentColor: Color
    let delay: Double
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var appear = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(0.12))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(accentColor.opacity(0.8))
                }
                
                Text(title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.black.opacity(0.78))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black.opacity(0.2))
                    .offset(x: isPressed ? 4 : 0)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(buttonBackground)
            .shadow(color: accentColor.opacity(0.08), radius: isPressed ? 4 : 12, x: 0, y: isPressed ? 2 : 4)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.97 : (appear ? 1.0 : 0.95))
        .opacity(appear ? 1.0 : 0.0)
        .offset(y: appear ? 0 : 10)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay + 0.3)) {
                appear = true
            }
        }
        .onLongPressGesture(
            minimumDuration: .infinity,
            maximumDistance: 50,
            pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isPressed = pressing
                }
                if pressing {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }
            },
            perform: {}
        )
    }
    
    private var buttonBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.9))
            
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.8), Color.white.opacity(0.4)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        }
    }
}

#Preview {
    HomeView()
}