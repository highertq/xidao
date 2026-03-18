import SwiftUI
import UIKit

struct MeditationView: View {
    let emotion: String
    let onDismiss: () -> Void
    
    @State private var countdown: Int = 3
    @State private var showCountdown: Bool = true
    @State private var isPlaying = true
    @State private var breathScale: CGFloat = 0.6
    @State private var breathOpacity: Double = 0.3
    @State private var showText = false
    @State private var breathPhase: BreathPhase = .inhale
    @State private var meditationSeconds: Int = 0
    @State private var currentQuote: String = ""
    @State private var targetDuration: Int = 0
    @State private var showDurationPicker = false
    @State private var isCompleted = false
    @State private var countdownScale: CGFloat = 0.5
    @State private var breathTimer: Timer?
    @State private var selectedBreathMethod: BreathMethod = .method478
    @State private var showCompletion = false
    @State private var completionQuote: (String, String) = ("", "")
    @State private var showCelebration = false
    @State private var celebrationScale: CGFloat = 1.0
    
    enum BreathPhase: String {
        case inhale = "吸气"
        case hold = "屏息"
        case exhale = "呼气"
    }
    
    enum BreathMethod: String, CaseIterable, Identifiable {
        case method478 = "4-7-8"
        case box = "盒式"
        
        var id: String { rawValue }
        
        var phases: [(phase: BreathPhase, duration: Int)] {
            switch self {
            case .method478:
                return [(.inhale, 4), (.hold, 7), (.exhale, 8)]
            case .box:
                return [(.inhale, 4), (.hold, 4), (.exhale, 4), (.hold, 4)]
            }
        }
    }
    
    let quotes = [
        "慢一点，世界不会跑掉。",
        "每一次呼吸，都是新的开始。",
        "你值得这一刻的宁静。",
        "让思绪随风飘散。",
        "此刻，只有你和呼吸。"
    ]
    
    let completionQuotes = [
        ("内心的平静，是最好的修行。", "—— 一行禅师"),
        ("静下来，才能听见内心的声音。", "—— 泰戈尔"),
        ("每一次呼吸，都是生命的礼物。", "—— 一行禅师"),
        ("宁静不是逃避，而是回归自己。", "—— 埃克哈特·托利"),
        ("当下这一刻，就是最好的时刻。", "—— 老子"),
        ("心若安静，世界便安静。", "—— 佛陀"),
        ("善待自己，从每一次呼吸开始。", "—— 一行禅师"),
        ("今天很残酷，明天更残酷，后天很美好。", "—— 马云"),
        ("心有多大，舞台就有多大。", "—— 史玉柱"),
        ("把简单的事情做到极致，就是绝招。", "—— 王健林"),
        ("梦想还是要有的，万一实现了呢。", "—— 马云"),
        ("人生就像一杯茶，不会苦一辈子，但总会苦一阵子。", "—— 林语堂"),
        ("真正的平静，不是避开车马喧嚣，而是在心中修篱种菊。", "—— 林清玄"),
        ("生活不是等待风暴过去，而是学会在雨中跳舞。", "—— 维维安·格林"),
        ("你若盛开，清风自来。", "—— 三毛"),
        ("慢下来，让灵魂跟上脚步。", "—— 印第安谚语"),
        ("简单的事重复做，你就是专家；重复的事用心做，你就是赢家。", "—— 稻盛和夫")
    ]
    
    let emotionActions: [String: String] = [
        "我很累": "告别疲惫",
        "我很焦虑": "拒绝焦虑",
        "我很烦躁": "平复烦躁",
        "我睡不着": "安然入睡",
        "我需要专注": "找回专注"
    ]
    
    let durationOptions = [
        ("片刻宁静", 60),
        ("短暂休憩", 180),
        ("悠然冥想", 300),
        ("深度放松", 600)
    ]
    
    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.98, blue: 0.99)
                .ignoresSafeArea()
            
            if showCountdown {
                countdownView
            } else if showCompletion {
                completionView
            } else {
                meditationContentView
            }
        }
        .onAppear {
            startCountdown()
        }
    }
    
    private var countdownView: some View {
        ZStack {
            VStack(spacing: 24) {
                Text(emotion)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black.opacity(0.4))
                
                Text("准备开始")
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(.black.opacity(0.6))
                
                ZStack {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .stroke(
                                Color(red: 0.9, green: 0.92, blue: 0.95),
                                lineWidth: 1.5
                            )
                            .frame(width: 180 + CGFloat(index) * 40, height: 180 + CGFloat(index) * 40)
                            .opacity(0.5)
                    }
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.95, green: 0.96, blue: 0.98).opacity(0.8),
                                    Color(red: 0.92, green: 0.94, blue: 0.96).opacity(0.5),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 70
                            )
                        )
                        .frame(width: 140, height: 140)
                    
                    Text(countdown > 0 ? "\(countdown)" : "开始")
                        .font(.system(size: 56, weight: .light, design: .rounded))
                        .foregroundColor(.black.opacity(0.7))
                        .scaleEffect(countdownScale)
                }
                .frame(height: 260)
            }
        }
    }
    
    private var completionView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 32) {
                Text("✨")
                    .font(.system(size: 48))
                
                VStack(spacing: 8) {
                    Text("冥想完成")
                        .font(.system(size: 28, weight: .light))
                        .foregroundColor(.black.opacity(0.7))
                    
                    Text("你已坚持 \(formatDuration(meditationSeconds))")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.black.opacity(0.4))
                }
                
                VStack(spacing: 12) {
                    Text(completionQuote.0)
                        .font(.system(size: 18, weight: .light, design: .serif))
                        .foregroundColor(.black.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Text(completionQuote.1)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.black.opacity(0.35))
                }
                .padding(.top, 16)
            }
            
            Spacer()
            
            ZStack {
                Button(action: {
                    triggerCelebration()
                }) {
                    Text(emotionActions[emotion] ?? "完成")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 160, height: 52)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.3, green: 0.6, blue: 0.5))
                        )
                }
                .scaleEffect(celebrationScale)
                
                if showCelebration {
                    MeditationCelebrationParticlesView()
                }
            }
            .padding(.bottom, 80)
        }
        .onAppear {
            completionQuote = completionQuotes.randomElement() ?? completionQuotes[0]
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
        }
    }
    
    private var meditationContentView: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    completionQuote = completionQuotes.randomElement() ?? completionQuotes[0]
                    showCompletion = true
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black.opacity(0.4))
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(Color(red: 0.95, green: 0.95, blue: 0.97))
                        )
                }
                Spacer()
                
                if targetDuration > 0 {
                    Text(formatTime(targetDuration - meditationSeconds))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black.opacity(0.4))
                } else {
                    Text(formatTime(meditationSeconds))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black.opacity(0.4))
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            
            Spacer()
            
            VStack(spacing: 16) {
                Text(emotion)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black.opacity(0.3))
                
                Text(currentQuote)
                    .font(.system(size: 22, weight: .light, design: .serif))
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .opacity(showText ? 1 : 0)
            }
            
            Spacer()
            
            ZStack {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .stroke(
                            Color(red: 0.9, green: 0.92, blue: 0.95),
                            lineWidth: 1.5
                        )
                        .frame(width: 200 + CGFloat(index) * 40, height: 200 + CGFloat(index) * 40)
                        .scaleEffect(breathScale + CGFloat(index) * 0.1)
                        .opacity(breathOpacity + Double(index) * 0.1)
                }
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.95, green: 0.96, blue: 0.98).opacity(0.8),
                                Color(red: 0.92, green: 0.94, blue: 0.96).opacity(0.5),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .scaleEffect(breathScale)
                    .opacity(breathOpacity + 0.3)
                
                VStack(spacing: 8) {
                    Text(breathPhase.rawValue)
                        .font(.system(size: 22, weight: .light))
                        .foregroundColor(.black.opacity(0.6))
                    
                    Text(phaseDurationText)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.black.opacity(0.3))
                }
            }
            
            Spacer()
            
            VStack(spacing: 20) {
                HStack(spacing: 8) {
                    ForEach(BreathMethod.allCases) { method in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedBreathMethod = method
                            }
                            triggerHaptic(style: .light)
                        }) {
                            Text(method.rawValue)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(selectedBreathMethod == method ? .black : .black.opacity(0.4))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(selectedBreathMethod == method ? Color(red: 0.9, green: 0.92, blue: 0.95) : Color.clear)
                                )
                        }
                    }
                }
                .padding(.bottom, 4)
                
                HStack(spacing: 16) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isPlaying.toggle()
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 18))
                            Text(isPlaying ? "暂停" : "继续")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.black.opacity(0.7))
                        .frame(width: 110, height: 48)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.95, green: 0.95, blue: 0.97))
                        )
                    }
                    
                    Button(action: {
                        showDurationPicker = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "clock")
                                .font(.system(size: 16))
                            Text(targetDuration > 0 ? formatDuration(targetDuration) : "定时")
                                .font(.system(size: 15, weight: .medium))
                        }
                        .foregroundColor(.black.opacity(0.6))
                        .frame(width: 110, height: 48)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.95, green: 0.95, blue: 0.97))
                        )
                    }
                }
                
                Button(action: {
                    completionQuote = completionQuotes.randomElement() ?? completionQuotes[0]
                    showCompletion = true
                }) {
                    Text("完成冥想")
                        .font(.system(size: 15))
                        .foregroundColor(.black.opacity(0.4))
                }
            }
            .padding(.bottom, 50)
        }
        .onAppear {
            currentQuote = quotes.randomElement() ?? quotes[0]
            showText = true
            startBreathing()
            startTimer()
        }
        .onChange(of: isPlaying) { _, newValue in
            if newValue {
                startBreathing()
            } else {
                breathTimer?.invalidate()
                breathTimer = nil
            }
        }
        .onChange(of: selectedBreathMethod) { _, _ in
            breathTimer?.invalidate()
            breathTimer = nil
            meditationSeconds = 0
            breathPhase = .inhale
            breathScale = 0.6
            breathOpacity = 0.3
            startBreathing()
        }
        .sheet(isPresented: $showDurationPicker) {
            DurationPickerSheet(
                options: durationOptions,
                onSelect: { seconds in
                    targetDuration = seconds
                    showDurationPicker = false
                },
                onSelectForever: {
                    targetDuration = 0
                    showDurationPicker = false
                }
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }
    
    var phaseDurationText: String {
        let phases = selectedBreathMethod.phases
        if let current = phases.first(where: { $0.phase == breathPhase }) {
            return "\(current.duration) 秒"
        }
        return ""
    }
    
    func startCountdown() {
        countdown = 3
        countdownScale = 1.0
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        
        func nextCount() {
            if countdown > 0 {
                impact.impactOccurred()
                
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    countdownScale = 1.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(.easeOut(duration: 0.2)) {
                        countdownScale = 0.5
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        countdown -= 1
                        if countdown > 0 {
                            nextCount()
                        } else {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                countdownScale = 1.0
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    showCountdown = false
                                }
                            }
                        }
                    }
                }
            }
        }
        
        nextCount()
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if isPlaying && !isCompleted && !showCountdown && !showCompletion {
                meditationSeconds += 1
                
                if targetDuration > 0 && meditationSeconds >= targetDuration {
                    isCompleted = true
                    completionQuote = completionQuotes.randomElement() ?? completionQuotes[0]
                    showCompletion = true
                }
            }
        }
    }
    
    func startBreathing() {
        guard isPlaying else { return }
        
        breathTimer?.invalidate()
        
        let phases = selectedBreathMethod.phases
        executePhase(phases: phases, index: 0)
    }
    
    func executePhase(phases: [(phase: BreathPhase, duration: Int)], index: Int) {
        guard isPlaying else { return }
        guard index < phases.count else {
            currentQuote = quotes.randomElement() ?? quotes[0]
            startBreathing()
            return
        }
        
        let currentPhase = phases[index]
        breathPhase = currentPhase.phase
        let duration = Double(currentPhase.duration)
        
        switch currentPhase.phase {
        case .inhale:
            triggerHaptic(style: .light)
            withAnimation(.easeInOut(duration: duration)) {
                breathScale = 1.0
                breathOpacity = 0.8
            }
        case .hold:
            triggerHaptic(style: .medium)
        case .exhale:
            triggerHaptic(style: .light)
            withAnimation(.easeInOut(duration: duration)) {
                breathScale = 0.6
                breathOpacity = 0.3
            }
        }
        
        breathTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            executePhase(phases: phases, index: index + 1)
        }
    }
    
    func triggerCelebration() {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            showCelebration = true
            celebrationScale = 1.1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            MeditationData.shared.completeMeditation()
            onDismiss()
        }
    }
    
    func triggerHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", mins, secs)
    }
    
    func formatDuration(_ seconds: Int) -> String {
        if seconds >= 60 {
            let mins = seconds / 60
            let secs = seconds % 60
            if secs > 0 {
                return "\(mins)分\(secs)秒"
            }
            return "\(mins)分钟"
        }
        return "\(seconds)秒"
    }
}

struct MeditationCelebrationParticlesView: View {
    @State private var particles: [MeditationCelebrationParticle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                MeditationCelebrationParticleView(particle: particle)
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
        
        for i in 0..<16 {
            let angle = Double(i) * (360.0 / 16.0) * .pi / 180.0
            let distance = CGFloat.random(in: 60...120)
            let particle = MeditationCelebrationParticle(
                id: i,
                color: colors[i % colors.count],
                angle: angle,
                distance: distance,
                size: CGFloat.random(in: 6...12),
                delay: Double.random(in: 0...0.15)
            )
            particles.append(particle)
        }
    }
}

struct MeditationCelebrationParticle: Identifiable {
    let id: Int
    let color: Color
    let angle: Double
    let distance: CGFloat
    let size: CGFloat
    let delay: Double
}

struct MeditationCelebrationParticleView: View {
    let particle: MeditationCelebrationParticle
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
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeIn(duration: 0.3)) {
                            opacity = 0
                            scale = 0.5
                        }
                    }
                }
            }
    }
}

struct DurationPickerSheet: View {
    let options: [(String, Int)]
    let onSelect: (Int) -> Void
    let onSelectForever: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Text("选择时长")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)
                .padding(.top, 20)
                .padding(.bottom, 24)
            
            VStack(spacing: 12) {
                ForEach(options, id: \.1) { option in
                    Button(action: { onSelect(option.1) }) {
                        HStack {
                            Text(option.0)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Text(option.1 >= 60 ? "\(option.1 / 60) 分钟" : "\(option.1) 秒")
                                .font(.system(size: 15))
                                .foregroundColor(.black.opacity(0.5))
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(red: 0.96, green: 0.97, blue: 0.98))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Button(action: { onSelectForever() }) {
                    HStack {
                        Text("随心冥想")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text("不限时长")
                            .font(.system(size: 15))
                            .foregroundColor(.black.opacity(0.5))
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(red: 0.96, green: 0.97, blue: 0.98))
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.99))
    }
}

#Preview {
    MeditationView(emotion: "我很焦虑", onDismiss: {})
}