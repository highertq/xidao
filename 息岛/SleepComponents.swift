import SwiftUI

struct WaveView: View {
    let phase: CGFloat
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                let width = size.width
                let height = size.height
                
                var path = Path()
                path.move(to: CGPoint(x: 0, y: height))
                
                for x in stride(from: 0, through: width, by: 2) {
                    let relativeX = CGFloat(x) / width
                    let y = height * 0.5 +
                        sin((relativeX + CGFloat(time * 0.1)) * .pi * 3) * 8 +
                        sin((relativeX * 2 + CGFloat(time * 0.15)) * .pi * 2) * 4
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                
                path.addLine(to: CGPoint(x: width, y: height))
                path.closeSubpath()
                
                context.fill(
                    path,
                    with: .color(Color(red: 0.88, green: 0.92, blue: 0.96))
                )
            }
        }
    }
}

struct TimerDuration: Identifiable {
    let id = UUID()
    let title: String
    let minutes: Int
}

struct TimerSelectionSheet: View {
    let options: [TimerDuration]
    let onSelect: (TimerDuration) -> Void
    let onSelectForever: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 12)
            
            Text("选择时长")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
                .padding(.bottom, 20)
            
            VStack(spacing: 10) {
                ForEach(options) { option in
                    Button(action: { onSelect(option) }) {
                        HStack {
                            Text(option.title)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Text("\(option.minutes)分钟")
                                .font(.system(size: 15))
                                .foregroundColor(.black.opacity(0.4))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.96, green: 0.97, blue: 0.98))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Button(action: { onSelectForever() }) {
                    HStack {
                        Text("无尽宁静")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Image(systemName: "infinity")
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.4))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
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

struct SleepScene: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
}

struct SleepSceneCard: View {
    let scene: SleepScene
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(scene.color.opacity(0.12))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: scene.icon)
                        .font(.system(size: 20))
                        .foregroundColor(scene.color)
                    
                    if isSelected {
                        Circle()
                            .stroke(scene.color, lineWidth: 2)
                            .frame(width: 48, height: 48)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(scene.title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(scene.subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.black.opacity(0.4))
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(isSelected ? 0.1 : 0.04), radius: isSelected ? 12 : 8, y: isSelected ? 4 : 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(scene.color.opacity(isSelected ? 0.3 : 0), lineWidth: 1.5)
                    )
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}
