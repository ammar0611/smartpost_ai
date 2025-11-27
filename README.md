# SmartPost AI ✨

![Flutter](https://img.shields.io/badge/Flutter-3.5.4-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Mobile-orange)

**SmartPost AI** is a modern, AI-powered content creation platform built with Flutter. Generate engaging text and stunning images using advanced AI models from Google Gemini and Hugging Face.

## 🌟 Features

- **🤖 AI Text Generation** - Powered by Google Gemini for high-quality content
- **🎨 AI Image Generation** - Multiple models including FLUX.1 and Stable Diffusion
- **📱 Fully Responsive** - Optimized for mobile, tablet, and web (Chrome)
- **🎯 Modern UI/UX** - Clean, professional design with smooth interactions
- **🔐 Secure API Management** - Store and manage API keys via Firebase Firestore
- **⚡ Real-time Processing** - Fast content generation with loading states
- **💾 Persistent Settings** - Your preferences saved automatically

## 🎨 Design Highlights

- **Modern Color Palette** - Purple gradients with cyan and pink accents
- **Responsive Layouts** - Adaptive UI for all screen sizes
- **Custom Components** - Reusable widgets for consistent design
- **Smooth Animations** - Elegant loading states and transitions
- **Professional Typography** - OpenSans font family throughout

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.5.4 or higher
- Firebase project configured
- API Keys:
  - Google Gemini API key
  - Hugging Face API key

### Installation

```bash
# Clone the repository
git clone https://github.com/ammar0611/smartpost_ai.git
cd smartpost_ai

# Install dependencies
flutter pub get

# Run on web (Chrome)
flutter run -d chrome

# Run on mobile
flutter run
```

### Firebase Setup

1. Create a Firebase project
2. Add your `google-services.json` to `android/app/`
3. Create these Firestore collections:
   - `currentGeminiApiKey`
   - `currentHfApiKey`
   - `huggingFaceApiKeys`

## 📱 Screenshots

### Desktop View
Beautiful two-column layout optimized for large screens with maximum content width constraints.

### Mobile View
Single-column responsive design with touch-friendly controls and optimized spacing.

### Settings
Elegant settings interface for managing API keys with real-time Firebase integration.

## 🏗️ Architecture

```
lib/
├── features/
│   ├── gen_ai/              # Main content generation
│   └── settings/            # Settings management
├── utils/
│   ├── theme_data.dart      # App theme configuration
│   ├── custom_widgets.dart  # Reusable UI components
│   └── responsive_utils.dart # Responsive helpers
├── values/
│   ├── colors.dart          # Color constants
│   └── constant.dart        # App constants
└── main.dart                # App entry point
```

## 🎯 Tech Stack

- **Framework**: Flutter 3.5.4
- **State Management**: Provider
- **Backend**: Firebase (Firestore, Auth)
- **AI APIs**:
  - Google Gemini (Text Generation)
  - Hugging Face (Image Generation)
- **Local Storage**: SharedPreferences
- **HTTP Client**: http package

## 📚 Documentation

- [Design System](DESIGN_SYSTEM.md) - Complete design guidelines and component documentation
- [Quick Start Guide](QUICK_START.md) - Detailed setup and usage instructions

## 🎨 Key Components

### Custom Widgets
- `GradientButton` - Modern gradient buttons with loading states
- `CustomCard` - Elevated cards with shadows
- `CustomDropdown` - Styled dropdowns with icon support
- `EmptyStateWidget` - Beautiful empty state placeholders

### Responsive Utilities
- `ResponsiveLayout` - Automatic layout adaptation
- `MaxWidthContainer` - Content width constraints
- `ResponsivePadding` - Adaptive spacing

## 🔧 Configuration

### API Keys
Update Firebase Firestore or `lib/values/constant.dart`:

```dart
static const String geminiApiKey = 'your-gemini-key';
static const String HFApiKey = 'your-huggingface-key';
```

### Breakpoints
```dart
static const breakPoint_480 = 480;   // Mobile
static const breakPoint_800 = 800;   // Tablet
static const breakPoint_1000 = 1000; // Desktop
```

## 🎯 Features in Detail

### Text Generation
- Powered by Google Gemini API
- Natural language understanding
- Context-aware responses
- Copy to clipboard functionality

### Image Generation
- Multiple model support:
  - FLUX.1 Schnell (Fast)
  - FLUX.1 Dev (Quality)
  - Stable Diffusion XL
- High-resolution outputs
- Download generated images
- Real-time generation status

### Settings Management
- Multiple API key support
- Switch between keys instantly
- Secure Firebase storage
- Real-time synchronization

## 🌐 Supported Platforms

- ✅ Web (Chrome, Edge, Firefox, Safari)
- ✅ Android
- ✅ iOS
- ✅ Windows (Desktop)
- ✅ macOS (Desktop)
- ✅ Linux (Desktop)

## 📦 Dependencies

Key packages:
- `flutter_gemini` - Gemini AI integration
- `cloud_firestore` - Firebase database
- `provider` - State management
- `loader_overlay` - Loading overlays
- `http` - API requests
- `shared_preferences` - Local storage

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

**Ammar**
- GitHub: [@ammar0611](https://github.com/ammar0611)

## 🙏 Acknowledgments

- Google Gemini for powerful text generation
- Hugging Face for amazing image generation models
- Flutter team for the excellent framework
- Firebase for robust backend services

## 📞 Support

For support, email or open an issue in the GitHub repository.

---

Made with ❤️ using Flutter
