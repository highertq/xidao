import SwiftUI

struct SplashView: View {
    @Binding var isActive: Bool
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var rotation: Double = -30
    @State private var circleScale: CGFloat = 0.5
    @State private var circleOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var textOffset: CGFloat = 20
    
    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.98, blue: 0.99)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                ZStack {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .stroke(
                                Color.black.opacity(0.05),
                                lineWidth: 1
                            )
                            .frame(width: 140 + CGFloat(index) * 30, height: 140 + CGFloat(index) * 30)
                            .scaleEffect(circleScale + CGFloat(index) * 0.08)
                            .opacity(circleOpacity)
                    }
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.96, green: 0.97, blue: 0.98),
                                    Color(red: 0.93, green: 0.94, blue: 0.96).opacity(0.5),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 50
                            )
                        )
                        .frame(width: 100, height: 100)
                        .scaleEffect(circleScale)
                        .opacity(circleOpacity)
                    
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(.black.opacity(0.25))
                        .rotationEffect(.degrees(rotation))
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
                
                VStack(spacing: 12) {
                    Text("息岛")
                        .font(.system(size: 36, weight: .light, design: .serif))
                        .foregroundColor(.black.opacity(0.7))
                        .opacity(textOpacity)
                        .offset(y: textOffset)
                    
                    Text("找到内心的平静")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.black.opacity(0.4))
                        .opacity(textOpacity)
                        .offset(y: textOffset)
                }
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    func startAnimation() {
        withAnimation(.easeOut(duration: 0.8)) {
            opacity = 1
            scale = 1.0
            rotation = 0
        }
        
        withAnimation(.easeOut(duration: 1.2).delay(0.2)) {
            circleScale = 1.0
            circleOpacity = 1.0
        }
        
        withAnimation(.easeOut(duration: 0.8).delay(0.6)) {
            textOpacity = 1.0
            textOffset = 0
        }
        
        withAnimation(.easeInOut(duration: 4).delay(1.5).repeatForever(autoreverses: true)) {
            circleScale = 1.08
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeIn(duration: 0.6)) {
                isActive = false
            }
        }
    }
}

#Preview {
    SplashView(isActive: .constant(true))
}
