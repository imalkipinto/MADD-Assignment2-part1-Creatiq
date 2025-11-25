# Creatiq — Craft. Create. Influence.

<p align="center">
  <img src="creatiq_logo.png" alt="Creatiq App Icon" width="160" />
</p>

<p align="center"><strong>The ultimate all-in-one mobile studio for influencers, creators, and digital storytellers.</strong><br/>
Plan posts, generate AI captions, build stunning moodboards, track outfits, and elevate your creative workflow.</p>

---

<!-- Badges -->
<p align="center">
  <a href="https://github.com/imalkipinto/MADD-Assignment2-part1-Creatiq"><img alt="Repo" src="https://img.shields.io/badge/repo-Creatiq-blue?logo=github" /></a>
  <img alt="Platform" src="https://img.shields.io/badge/platform-iOS-lightgrey?logo=apple" />
  <img alt="Language" src="https://img.shields.io/badge/language-Swift-orange?logo=swift" />
  <img alt="License" src="https://img.shields.io/badge/license-MIT-green" />
</p>

---

## Overview

Creatiq is an elite AI content studio built for creators who want to plan, produce and polish social content quickly and beautifully. It's designed with iOS-first UX using SwiftUI and advanced UIKit animations, and powered by Core ML and the Gemini API for powerful on-device + cloud caption generation.

- Ideal for Instagram & TikTok creators — Creatiq follows a similar visual and interaction theme to popular content creation apps on those platforms.  
  <a href="h[ttps://www.instagram.com](https://i.pinimg.com/736x/19/42/d5/1942d5deb0f788e6228054cd92767ff6.jpg)" target="_blank" rel="noreferrer"><img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/instagram/instagram-original.svg" alt="instagram" width="30" /></a>
  <a href="https://www.tiktok.com" target="_blank" rel="noreferrer"><img src="https://upload.wikimedia.org/wikipedia/commons/e/e1/TikTok_logo.svg" alt="tiktok" width="32" /></a>

---

## Hero Features — at a glance

- 🚀 Smart Post Planner
  - Full CRUD with Core Data
  - Schedule posts and receive reminders
  - Timeline & beautiful post cards
  - Rich caption editor, image/date pickers

- ✨ AI Caption Generator (Core ML + Gemini API)
  - Local Core ML model for offline privacy
  - Gemini API for cloud, trend-aware captions + hashtags
  - Select tone: Aesthetic, Bold, Minimal, Funny, etc.
  - One-tap copy to clipboard

- 🎨 Moodboard Designer (Pinterest-style)
  - Upload and arrange images into moodboards
  - Auto-tagging via ML theme classifier (Classic, Dreamy, Bold)
  - Add background audio and smooth, interactive UI animations
  - Fullscreen previews and trending-theme popups

- 👗 Outfit Tracker
  - Add daily outfits with photos
  - Vision framework extracts dominant colors and builds circular palettes
  - Outfit logs for influencers, models and stylists

---

## Screenshots

<p align="center">
  <img src="URL_TO_DASHBOARD_SCREENSHOT" alt="Dashboard" width="260" />
  <img src="URL_TO_CAPTION_GENERATOR_SCREENSHOT" alt="Caption Generator" width="260" />
  <img src="URL_TO_MOODBOARD_SCREENSHOT" alt="Moodboard" width="260" />
</p>

Replace placeholder URLs above with screenshots hosted in this repository (recommended path: /assets/screenshots/).

---

## Tech Stack

<table>
  <tr>
    <th align="left">Layer</th>
    <th align="left">Technology</th>
  </tr>
  <tr>
    <td>UI</td>
    <td>SwiftUI + UIKit (compositional layout & animations)</td>
  </tr>
  <tr>
    <td>Architecture</td>
    <td>MVVM + Clean Modules</td>
  </tr>
  <tr>
    <td>AI</td>
    <td>Core ML (local), Google Gemini API (cloud)</td>
  </tr>
  <tr>
    <td>Database</td>
    <td>Core Data</td>
  </tr>
  <tr>
    <td>Media</td>
    <td>PhotosPicker, AVFoundation</td>
  </tr>
  <tr>
    <td>System</td>
    <td>UserNotifications, VisionKit</td>
  </tr>
</table>

<p>
  Integrations & tools:
  <a href="https://www.oracle.com/" target="_blank" rel="noreferrer"><img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/oracle/oracle-original.svg" alt="oracle" width="40" height="40"/></a>
  <a href="https://www.photoshop.com/en" target="_blank" rel="noreferrer"><img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/photoshop/photoshop-line.svg" alt="photoshop" width="40" height="40"/></a>
  <a href="https://www.php.net" target="_blank" rel="noreferrer"><img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/php/php-original.svg" alt="php" width="40" height="40"/></a>
  <a href="https://www.python.org" target="_blank" rel="noreferrer"><img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" alt="python" width="40" height="40"/></a>
  <a href="https://reactjs.org/" target="_blank" rel="noreferrer"><img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/react/react-original-wordmark.svg" alt="react" width="40" height="40"/></a>
  <a href="https://reactnative.dev/" target="_blank" rel="noreferrer"><img src="https://reactnative.dev/img/header_logo.svg" alt="reactnative" width="40" height="40"/></a>
  <a href="https://spring.io/" target="_blank" rel="noreferrer"><img src="https://www.vectorlogo.zone/logos/springio/springio-icon.svg" alt="spring" width="40" height="40"/></a>
  <a href="https://vuejs.org/" target="_blank" rel="noreferrer"><img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/vuejs/vuejs-original-wordmark.svg" alt="vuejs" width="40" height="40"/></a>
</p>

---

## Project Structure

Creatiq/
│
├── Models/
│   ├── Post.swift
│   ├── MoodboardItem.swift
│   ├── Outfit.swift
│   └── CaptionModel.mlmodel
│
├── ViewModels/
│   ├── DashboardViewModel.swift
│   ├── PostPlannerViewModel.swift
│   ├── AICaptionViewModel.swift
│   ├── MoodboardViewModel.swift
│   └── OutfitViewModel.swift
│
├── Views/
│   ├── DashboardView.swift
│   ├── PostPlannerView.swift
│   ├── AddPostView.swift
│   ├── AICaptionGeneratorView.swift
│   ├── MoodboardView.swift
│   ├── OutfitTrackerView.swift
│   └── Onboarding/
│
├── CoreData/
│   └── Creatiq.xcdatamodeld
│
├── Services/
│   ├── NotificationManager.swift
│   ├── GeminiAPI.swift
│   └── ThemeClassifier.swift
│
└── Assets/

---

## Quick Start / Setup

1. Clone the project
```bash
git clone https://github.com/imalkipinto/MADD-Assignment2-part1-Creatiq.git
cd MADD-Assignment2-part1-Creatiq
```

2. Install dependencies (if any; example CocoaPods)
```bash
# If CocoaPods used
pod install
```

3. Add your Gemini API key
- Create: `Creatiq/Secrets.plist`
- Add:
```xml
<dict>
  <key>GEMINI_API_KEY</key>
  <string>YOUR_API_KEY</string>
</dict>
```

4. Add your Core ML model
- Place model at: `Creatiq/Models/CaptionModel.mlmodel`

5. Enable required capabilities in Xcode
- Photo Library
- Camera (optional)
- Local Notifications
- Background Modes (audio playback for moodboards)

---

## How Caption Generation Works

Creatiq uses a hybrid AI pipeline:

- Local (Core ML)
  - Fast, offline, and private on-device generation.
- Cloud (Gemini API)
  - High-quality captions plus trend-aware hashtags for better engagement.
  - Example:
    - topic: "beach outfit"
    - tone: "aesthetic"
    - Gemini returns: "Salty hair, sun-kissed skin, and a heart full of waves 🌊✨" #beachvibes #sunsetfit #oceanmood

---

## Moodboard Music Feature

Each moodboard can attach:
- Local audio clip or playlist link
- Auto-looping player
- Enhances the aesthetic and storytelling experience

---

## Roadmap

- Live analytics for engagement predictions
- Cross-platform: iPadOS + macOS
- Multi-moodboard collaboration
- Export social media kits (Reels, Posts, Stories)

---

## Contributing

Pull requests are welcome! Please follow the existing folder structure & MVVM architecture. When contributing:
- Keep changes modular
- Add tests where relevant
- Update documentation and screenshots

---

## Support & ❤️

If you love Creatiq and want it to grow:
- Give the repo a Star ⭐
- Share feedback and ideas via Issues

Made with ❤️ for creators, by creators.  
Craft. Create. Influence.

---

