---
name: "swiftui-animation"
description: "Creates beautiful SwiftUI animations and visual effects including breathing animations, particle effects, gradient flows, and micro-interactions. Invoke when user wants to enhance UI with advanced animations."
---

# SwiftUI Animation & Visual Effects Skill

## Core Animation Techniques

### 1. Breathing & Meditation Animations
```swift
// Multi-layer breathing with organic movement
@State private var breathPhase: CGFloat = 0

// Use multiple animated circles with different timing
ForEach(0..<4) { i in
    Circle()
        .stroke(lineWidth: 1)
        .scaleEffect(1 + 0.15 * sin(breathPhase + Double(i) * 0.5))
        .opacity(0.3 + 0.2 * sin(breathPhase + Double(i) * 0.3))
}

// Animate with easeInOut for natural breathing rhythm
.withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
    breathPhase = .pi * 2
}
```

### 2. Organic Blob Shapes
```swift
// Use TimelineView for continuous organic shape morphing
TimelineView(.animation) { timeline in
    Canvas { context, size in
        let time = timeline.date.timeIntervalSinceReferenceDate
        // Draw bezier curves that morph over time
    }
}
```

### 3. Glassmorphism Effects
```swift
// Frosted glass background
.background(.ultraThinMaterial)
.overlay(
    RoundedRectangle(cornerRadius: 20)
        .stroke(Color.white.opacity(0.2), lineWidth: 1)
)
```

### 4. Particle & Sparkle Effects
```swift
// Floating particles
@State private var particles: [Particle] = []

struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var opacity: Double
    var scale: CGFloat
}

// Animate particles with random drift
```

### 5. Gradient Flow Animation
```swift
// Animated mesh gradient
MeshGradient(
    width: 3,
    height: 3,
    points: [
        .init(x: 0, y: 0), .init(x: 0.5, y: 0), .init(x: 1, y: 0),
        .init(x: 0, y: 0.5), .init(x: 0.5 + 0.2 * sin(phase), y: 0.5), .init(x: 1, y: 0.5),
        .init(x: 0, y: 1), .init(x: 0.5, y: 1), .init(x: 1, y: 1)
    ],
    colors: [.blue, .purple, .pink, .cyan, .white, .mint, .teal, .indigo, .blue]
)
```

### 6. Micro-interactions
```swift
// Spring animations for button presses
.scaleEffect(isPressed ? 0.95 : 1.0)
.animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)

// Haptic feedback
let impact = UIImpactFeedbackGenerator(style: .light)
impact.impactOccurred()
```

### 7. Text Effects
```swift
// Typewriter effect
Text(String(text.prefix(characterIndex)))
    .onAppear {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if characterIndex < text.count {
                characterIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }

// Gradient text
Text("Title")
    .foregroundStyle(
        LinearGradient(
            colors: [.blue, .purple],
            startPoint: .leading,
            endPoint: .trailing
        )
    )
```

## Color Palettes for Meditation Apps

```swift
// Calm & Serene
let calmColors = [
    Color(red: 0.94, green: 0.96, blue: 0.98),  // Soft blue-white
    Color(red: 0.92, green: 0.95, blue: 0.93),  // Mint cream
    Color(red: 0.96, green: 0.94, blue: 0.92),  // Warm white
]

// Deep Relaxation
let deepColors = [
    Color(red: 0.15, green: 0.25, blue: 0.35),  // Deep ocean
    Color(red: 0.25, green: 0.20, blue: 0.35),  // Twilight
    Color(red: 0.20, green: 0.30, blue: 0.28),  // Forest night
]
```

## Best Practices

1. **Performance**: Use `drawingGroup()` for complex animations
2. **Accessibility**: Respect `reduceMotion` setting
3. **Timing**: Use easeInOut for natural movement, linear for continuous rotation
4. **Layering**: Multiple subtle animations > one complex animation
5. **Color**: Keep opacity low (0.1-0.3) for overlays
