🎨 Creatiq – Craft. Create. Influence.
An Elite AI Content Studio for Influencers & Creators (iOS, SwiftUI, UIKit Animations, Core ML, Gemini API)
<p align="center"> <img src="YOUR_APP_ICON_URL" width="160" /> </p> <p align="center"> <strong>The ultimate all-in-one mobile studio for influencers, creators, and digital storytellers.</strong><br> Plan posts, generate AI captions, build stunning moodboards, track outfits, and elevate your creative workflow. </p>
🚀 Features
📅 Smart Post Planner
Full CRUD using Core Data
Schedule posts with notifications
Beautiful post cards + timeline view
Image Picker, Date Picker, and rich caption fields
Reminder alerts using UserNotifications
✨ AI Caption Generator (Core ML + Gemini API)
Enter your topic → instantly generate:
✔ AI caption
✔ AI hashtags
Choose tones: Aesthetic, Bold, Minimal, Funny, and more
Powered by:
Local Core ML model for offline generation
Gemini API for enhanced, cloud-based generation
One-tap Copy to Clipboard
🎨 Moodboard Designer (Pinterest-Style UI)
Upload images → create aesthetic moodboards
Auto-tagging using ML theme prediction (Classic, Dreamy, Formal, Bold)
Interactive animations using UIKit compositional layout
Add background songs to moodboards
Trending-theme popups: “Vintage Dreamy vibes are trending today 👀✨”
Fullscreen preview with smooth transitions
👗 Outfit Tracker
Add outfits with photos
Vision framework extracts dominant colors
Display as beautiful circular color palettes
Daily outfit log for creators and models
🧠 Powered by Intelligent Technologies
SwiftUI + UIKit hybrid animations
Core Data for persistence
Core ML for offline caption generation
Google Gemini API for cloud LLM captioning
VisionKit for color extraction
NavigationStack + MVVM Architecture
🖼️ Screenshots
<p align="center"> <img src="URL_TO_DASHBOARD_SCREENSHOT" width="260"/> <img src="URL_TO_CAPTION_GENERATOR_SCREENSHOT" width="260"/> <img src="URL_TO_MOODBOARD_SCREENSHOT" width="260"/> </p>
Replace the URLs with your own GitHub-hosted images.
🛠️ Tech Stack
Layer	Technology
UI	SwiftUI + UIKit Animations
Architecture	MVVM + Clean Modules
AI	Core ML (local), Gemini API (cloud)
Database	Core Data
Media	PhotosPicker, AVFoundation
System	UserNotifications, VisionKit
📁 Project Structure
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
🔑 Setup Guide
1️⃣ Clone the project
git clone https://github.com/yourusername/Creatiq.git
2️⃣ Install Pods (if you're using any)
pod install
3️⃣ Add your Gemini API key
Create:
Creatiq/Secrets.plist
Add:
<dict>
    <key>GEMINI_API_KEY</key>
    <string>YOUR_API_KEY</string>
</dict>
4️⃣ Add your Core ML Model
Place your model inside:
Creatiq/Models/CaptionModel.mlmodel
5️⃣ Enable Capabilities
Photo Library
Camera (optional)
Local Notifications
Background Modes (audio playback for moodboards)
💡 How Caption Generation Works
Creatiq uses a hybrid AI pipeline:
▶ Local (Core ML)
Fast, offline, private.
▶ Cloud (Gemini API)
High-quality captions + trend-aware hashtags:
topic: "beach outfit"
tone: "aesthetic"
Gemini returns:
"Salty hair, sun-kissed skin, and a heart full of waves 🌊✨"
#beachvibes #sunsetfit #oceanmood
🎵 Moodboard Music Feature
Each moodboard can attach:
Local audio clip
Playlist link
Auto-looping player
Enhances the aesthetic and storytelling experience.
🧩 Roadmap
 Live analytics for engagement predictions
 Cross-platform (iPadOS + macOS)
 Multi-moodboard collaboration
 Export social media kits (Reels, Posts, Stories)
📢 Contributing
Pull requests are welcome!
Please follow the existing folder structure & MVVM architecture.
⭐ Support
If you love Creatiq and want it to grow:
Give the Repo a Star ⭐
Your star helps the project reach more creators!
🪩 Craft. Create. Influence.
Made with ❤️ for creators, by creators.
