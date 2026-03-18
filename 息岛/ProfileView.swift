import SwiftUI
import UserNotifications

class MeditationData: ObservableObject {
    static let shared = MeditationData()
    
    @Published var todayMinutes: Int = 0
    @Published var streakDays: Int = 0
    @Published var lastMeditationDate: Date?
    
    private let todayMinutesKey = "todayMeditationMinutes"
    private let streakKey = "streakDays"
    private let lastDateKey = "lastMeditationDate"
    
    private init() {
        loadData()
    }
    
    func loadData() {
        let defaults = UserDefaults.standard
        todayMinutes = defaults.integer(forKey: todayMinutesKey)
        streakDays = defaults.integer(forKey: streakKey)
        
        if let dateData = defaults.data(forKey: lastDateKey) {
            lastMeditationDate = try? JSONDecoder().decode(Date.self, from: dateData)
        }
        
        checkAndResetDaily()
    }
    
    func addMeditationTime(_ minutes: Int) {
        todayMinutes += minutes
        saveData()
    }
    
    func completeMeditation() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastDate = lastMeditationDate {
            let lastDay = calendar.startOfDay(for: lastDate)
            let daysDiff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
            
            if daysDiff == 0 {
            } else if daysDiff == 1 {
                streakDays += 1
            } else {
                streakDays = 1
            }
        } else {
            streakDays = 1
        }
        
        lastMeditationDate = Date()
        todayMinutes += 1
        saveData()
    }
    
    private func checkAndResetDaily() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastDate = lastMeditationDate {
            let lastDay = calendar.startOfDay(for: lastDate)
            if lastDay < today {
                todayMinutes = 0
                saveData()
            }
        }
    }
    
    private func saveData() {
        let defaults = UserDefaults.standard
        defaults.set(todayMinutes, forKey: todayMinutesKey)
        defaults.set(streakDays, forKey: streakKey)
        
        if let date = lastMeditationDate {
            if let dateData = try? JSONEncoder().encode(date) {
                defaults.set(dateData, forKey: lastDateKey)
            }
        }
    }
}

class ReminderManager: ObservableObject {
    static let shared = ReminderManager()
    
    @Published var isEnabled: Bool = false
    @Published var reminderTime: Date = Date()
    
    private let enabledKey = "reminderEnabled"
    private let timeKey = "reminderTime"
    
    private init() {
        loadData()
    }
    
    func loadData() {
        let defaults = UserDefaults.standard
        isEnabled = defaults.bool(forKey: enabledKey)
        
        if let timeData = defaults.data(forKey: timeKey),
           let time = try? JSONDecoder().decode(Date.self, from: timeData) {
            reminderTime = time
        } else {
            reminderTime = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date()) ?? Date()
        }
        
        if isEnabled {
            scheduleReminder()
        }
    }
    
    func toggleReminder(_ enabled: Bool) {
        isEnabled = enabled
        saveData()
        
        if enabled {
            scheduleReminder()
        } else {
            cancelReminder()
        }
    }
    
    func updateTime(_ time: Date) {
        reminderTime = time
        saveData()
        
        if isEnabled {
            scheduleReminder()
        }
    }
    
    private func scheduleReminder() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "息岛"
                content.body = "是时候放松一下了，来一次深呼吸吧"
                content.sound = .default
                
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: self.reminderTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                
                let request = UNNotificationRequest(identifier: "meditationReminder", content: content, trigger: trigger)
                center.add(request)
            }
        }
    }
    
    private func cancelReminder() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["meditationReminder"])
    }
    
    private func saveData() {
        let defaults = UserDefaults.standard
        defaults.set(isEnabled, forKey: enabledKey)
        
        if let timeData = try? JSONEncoder().encode(reminderTime) {
            defaults.set(timeData, forKey: timeKey)
        }
    }
}

struct ProfileView: View {
    @StateObject private var meditationData = MeditationData.shared
    @StateObject private var reminderManager = ReminderManager.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.98, green: 0.98, blue: 0.99)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.95, green: 0.95, blue: 0.97))
                                    .frame(width: 90, height: 90)
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.black.opacity(0.5))
                            }
                            
                            Text("旅行者")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text("在息岛找到内心的平静")
                                .font(.system(size: 15))
                                .foregroundColor(.black.opacity(0.4))
                        }
                        .padding(.top, 30)
                        
                        HStack(spacing: 16) {
                            StatCard(
                                title: "今日冥想",
                                value: "\(meditationData.todayMinutes)",
                                unit: "分钟",
                                icon: "moon.zzz.fill"
                            )
                            
                            StatCard(
                                title: "连续放松",
                                value: "\(meditationData.streakDays)",
                                unit: "天",
                                icon: "flame.fill"
                            )
                        }
                        .padding(.horizontal, 24)
                        
                        VStack(spacing: 12) {
                            VStack(spacing: 0) {
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.95, green: 0.95, blue: 0.97))
                                            .frame(width: 40, height: 40)
                                        
                                        Image(systemName: "bell.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(.black.opacity(0.5))
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("提醒设置")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.black)
                                        
                                        Text(reminderManager.isEnabled ? "已开启" : "每日放松提醒")
                                            .font(.system(size: 13))
                                            .foregroundColor(.black.opacity(0.4))
                                    }
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: Binding(
                                        get: { reminderManager.isEnabled },
                                        set: { reminderManager.toggleReminder($0) }
                                    ))
                                    .labelsHidden()
                                }
                                .padding(16)
                                
                                if reminderManager.isEnabled {
                                    Divider()
                                        .padding(.leading, 72)
                                    
                                    HStack {
                                        Text("提醒时间")
                                            .font(.system(size: 15))
                                            .foregroundColor(.black.opacity(0.6))
                                        
                                        Spacer()
                                        
                                        DatePicker("", selection: Binding(
                                            get: { reminderManager.reminderTime },
                                            set: { reminderManager.updateTime($0) }
                                        ), displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 16)
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.03), radius: 6, y: 2)
                            )
                            
                            ProfileRow(icon: "lock.fill", title: "隐私安全", subtitle: "所有数据仅存储在本地")
                            
                            ProfileRow(icon: "info.circle.fill", title: "关于息岛", subtitle: "版本 1.0.0")
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer()
                            .frame(height: 120)
                    }
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(.black.opacity(0.5))
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.black)
                
                Text(unit)
                    .font(.system(size: 14))
                    .foregroundColor(.black.opacity(0.4))
            }
            
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.black.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.03), radius: 8, y: 2)
        )
    }
}

struct ProfileRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.95, green: 0.95, blue: 0.97))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.black.opacity(0.5))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.black.opacity(0.4))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.black.opacity(0.2))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.03), radius: 6, y: 2)
        )
    }
}

#Preview {
    ProfileView()
}
