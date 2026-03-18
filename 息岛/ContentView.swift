import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                
                SleepView()
                    .tag(1)
                
                ProfileView()
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            VStack {
                Spacer()
                
                HStack(spacing: 0) {
                    TabBarButton(
                        icon: "house.fill",
                        title: "首页",
                        isSelected: selectedTab == 0
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = 0
                        }
                    }
                    
                    TabBarButton(
                        icon: "moon.zzz.fill",
                        title: "睡眠",
                        isSelected: selectedTab == 1
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = 1
                        }
                    }
                    
                    TabBarButton(
                        icon: "person.fill",
                        title: "我的",
                        isSelected: selectedTab == 2
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = 2
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 28)
                .background(
                    Rectangle()
                        .fill(Color.white.opacity(0.95))
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }
        .ignoresSafeArea()
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(Color(red: 0.95, green: 0.95, blue: 0.97))
                            .frame(width: 44, height: 44)
                    }
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(isSelected ? .black : .gray.opacity(0.5))
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                
                Text(title)
                    .font(.system(size: 11, weight: isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? .black : .gray.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ContentView()
}
