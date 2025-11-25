<div align="center">

# ✨ Creatiq

### *Create Your Aesthetic. Influence with Intention.*

<!-- Replace this placeholder with your actual app banner -->
<img src="https://via.placeholder.com/800x200/667eea/ffffff?text=✨+CREATIQ+-+Create+Your+Aesthetic" alt="Creatiq Banner" width="800"/>

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg?style=for-the-badge&logo=swift)](https://swift.org)
[![UIKit](https://img.shields.io/badge/UIKit-Animations-blue.svg?style=for-the-badge&logo=apple)](https://developer.apple.com/documentation/uikit)
[![CoreML](https://img.shields.io/badge/CoreML-Powered-green.svg?style=for-the-badge&logo=apple)](https://developer.apple.com/documentation/coreml)
[![Gemini](https://img.shields.io/badge/Gemini-API-purple.svg?style=for-the-badge&logo=google)](https://ai.google.dev/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

---

**Creatiq** is a powerful iOS application designed to ease the lives of content creators and influencers. Craft premium content effortlessly with AI-powered caption generation and stunning animations.

[Features](#-features) • [Screenshots](#-screenshots) • [Tech Stack](#-tech-stack) • [Installation](#-installation) • [API Setup](#-api-setup) • [Contributing](#-contributing)

</div>

---

## 🚀 Features

<table>
<tr>
<td width="50%">

### 🎨 **Beautiful UI with UIKit Animations**
Smooth, polished animations that make content creation a delightful experience. Every interaction feels premium and responsive.

</td>
<td width="50%">

### 🧠 **AI-Powered Caption Generation**
Leveraging CoreML and Gemini API for intelligent, context-aware caption suggestions that resonate with your audience.

</td>
</tr>
<tr>
<td width="50%">

### ⚡ **Swift Performance**
Built entirely in Swift for optimal performance, reliability, and a native iOS experience.

</td>
<td width="50%">

### 🔗 **Gemini API Integration**
Seamlessly connected to Google's Gemini API for advanced language model capabilities and creative content generation.

</td>
</tr>
</table>

---

## 📸 Screenshots

<div align="center">

<!-- Replace these placeholder images with actual app screenshots -->

| Home Screen | Caption Generator | Content Editor |
|:-----------:|:-----------------:|:--------------:|
| <img src="https://via.placeholder.com/200x400/764ba2/ffffff?text=Home+Screen" alt="Home Screen" width="200"/> | <img src="https://via.placeholder.com/200x400/667eea/ffffff?text=Caption+Generator" alt="Caption Generator" width="200"/> | <img src="https://via.placeholder.com/200x400/f093fb/ffffff?text=Content+Editor" alt="Content Editor" width="200"/> |

| AI Suggestions | Profile | Settings |
|:--------------:|:-------:|:--------:|
| <img src="https://via.placeholder.com/200x400/4facfe/ffffff?text=AI+Suggestions" alt="AI Suggestions" width="200"/> | <img src="https://via.placeholder.com/200x400/43e97b/ffffff?text=Profile" alt="Profile" width="200"/> | <img src="https://via.placeholder.com/200x400/fa709a/ffffff?text=Settings" alt="Settings" width="200"/> |

</div>

---

## 🛠 Tech Stack

<div align="center">

| Technology | Purpose |
|:----------:|:--------|
| <img src="https://img.shields.io/badge/Swift-FA7343?style=flat-square&logo=swift&logoColor=white" height="25"/> | Primary programming language for iOS development |
| <img src="https://img.shields.io/badge/UIKit-2396F3?style=flat-square&logo=apple&logoColor=white" height="25"/> | UI framework with custom animations |
| <img src="https://img.shields.io/badge/CoreML-34C759?style=flat-square&logo=apple&logoColor=white" height="25"/> | On-device machine learning for caption generation |
| <img src="https://img.shields.io/badge/Gemini_API-8E75B2?style=flat-square&logo=google&logoColor=white" height="25"/> | External LLM for advanced AI capabilities |
| <img src="https://img.shields.io/badge/Xcode-147EFB?style=flat-square&logo=xcode&logoColor=white" height="25"/> | IDE and build system |

</div>

---

## 📦 Installation

### Prerequisites

- macOS 13.0 or later
- Xcode 15.0 or later
- iOS 16.0+ deployment target
- Valid Apple Developer account (for device testing)

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/imalkipinto/MADD-Assignment2-part1-Creatiq.git
   cd MADD-Assignment2-part1-Creatiq
   ```

2. **Open the project in Xcode**
   ```bash
   open Creatiq.xcodeproj
   ```

3. **Install dependencies** (if using CocoaPods/SPM)
   ```bash
   pod install
   # or
   swift package resolve
   ```

4. **Configure your API keys** (see [API Setup](#-api-setup) below)

5. **Build and run**
   - Select your target device/simulator
   - Press `Cmd + R` or click the Run button

---

## 🔑 API Setup

### Gemini API Configuration

To enable AI-powered features, you need to configure your Gemini API key:

1. **Get your API key**
   - Visit [Google AI Studio](https://aistudio.google.com/app/apikey)
   - Create a new API key for your project

2. **Add the key to your project**
   
   Create a `Config.plist` file in your project root:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>GEMINI_API_KEY</key>
       <string>YOUR_API_KEY_HERE</string>
   </dict>
   </plist>
   ```

3. **Add `Config.plist` to your `.gitignore`**
   
   Open your `.gitignore` file and add the following line:
   ```
   Config.plist
   ```

> ⚠️ **Security Note**: Never commit your API keys to version control!

---

## 🏗 Architecture

```
Creatiq/
├── 📁 App/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── 📁 Features/
│   ├── 📁 CaptionGenerator/
│   │   ├── CaptionViewController.swift
│   │   └── CaptionViewModel.swift
│   ├── 📁 ContentEditor/
│   │   └── EditorViewController.swift
│   └── 📁 Profile/
│       └── ProfileViewController.swift
├── 📁 Services/
│   ├── GeminiAPIService.swift
│   └── CoreMLService.swift
├── 📁 Animations/
│   └── UIKitAnimations.swift
├── 📁 Models/
│   └── Caption.mlmodel
└── 📁 Resources/
    └── Assets.xcassets
```

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/AmazingFeature`)
3. **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** to the branch (`git push origin feature/AmazingFeature`)
5. **Open** a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- [Apple Developer Documentation](https://developer.apple.com/documentation/) for UIKit and CoreML resources
- [Google AI](https://ai.google.dev/) for the Gemini API
- All content creators and influencers who inspired this project

---

<div align="center">

**Made with ❤️ for Content Creators**

<!-- Replace this placeholder with your actual footer image -->
<img src="https://via.placeholder.com/400x100/667eea/ffffff?text=Creatiq+-+Influence+with+Intention" alt="Creatiq Footer" width="400"/>

*Create Your Aesthetic. Influence with Intention.*

</div>
