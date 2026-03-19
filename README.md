# 息岛 - Island of Rest

一个帮助你放松、冥想、改善睡眠的 iOS 应用。

## 功能特色

### 🏠 首页
- 精美的呼吸动画效果
- 多种情绪选择：我很累、我很焦虑、我很烦躁、我睡不着、我需要专注
- 点击叶子图标有触觉反馈

### 🧘 冥想
- 科学呼吸训练：4-7-8 呼吸法 & 盒式呼吸法
- 开始前 3 秒倒计时
- 冥想完成庆祝页面 + 名人名言
- 个性化完成按钮文案

### 🌙 睡眠
- 5 种白噪音：雨声、海浪、火焰、森林、宇宙
- 定时功能：1分钟、3分钟、5分钟、15分钟、30分钟、60分钟
- 长按 2 秒停止播放，带进度条动画
- 停止后有撒花庆祝特效

### 👤 我的
- 冥想记录统计
- 连续放松天数

## 技术栈

- **SwiftUI** - 现代声明式 UI 框架
- **AVFoundation** - 音频播放
- **Combine** - 响应式编程

## 项目结构

```
息岛/
├── __App.swift              # App 入口
├── ContentView.swift        # 主 Tab 视图
├── HomeView.swift           # 首页
├── MeditationView.swift      # 冥想页面
├── SleepView.swift          # 睡眠白噪音页面
├── ProfileView.swift        # 个人中心
├── SplashView.swift         # 开屏动画
├── WaveTimerCard.swift     # 波浪计时卡片
├── SleepComponents.swift    # 睡眠组件
├── AudioManager.swift       # 音频管理
└── Assets.xcassets/         # 图片资源
```

## 运行项目

1. 克隆仓库
2. 用 Xcode 打开 `息岛.xcodeproj`
3. 选择模拟器或真机
4. 运行项目 (⌘R)

## 配置后台音频

如需支持后台播放音频：
1. 在 Xcode 中选择项目 → Target → Signing & Capabilities
2. 点击 + Capability → 添加 Background Modes
3. 勾选 Audio, AirPlay, and Picture in Picture

## 音频文件

需要添加以下 mp3 文件到项目中：
- rain.mp3
- ocean.mp3
- fire.mp3
- forest.mp3
- universe.mp3

## 许可证

MIT License