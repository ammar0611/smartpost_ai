# SmartPost AI - Quick Start Guide

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.5.4 or higher)
- Firebase project configured
- Gemini API key
- Hugging Face API key

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd smartpost_ai
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Firebase**
- Place your `google-services.json` in `android/app/`
- Update `firebase_options.dart` with your configuration

4. **Run the app**
```bash
# For Web (Chrome)
flutter run -d chrome

# For Mobile
flutter run -d <device-id>

# For Windows
flutter run -d windows
```

## 🎨 Design System Usage

### Using Custom Widgets

#### 1. Gradient Button
```dart
import 'package:smartpost_ai/utils/custom_widgets.dart';

GradientButton(
  text: 'Click Me',
  icon: Icons.send,
  onPressed: () {
    // Your action
  },
  isLoading: false,
)
```

#### 2. Custom Card
```dart
import 'package:smartpost_ai/utils/custom_widgets.dart';

CustomCard(
  padding: EdgeInsets.all(24),
  child: Column(
    children: [
      Text('Card Title'),
      Text('Card content goes here'),
    ],
  ),
)
```

#### 3. Custom Dropdown
```dart
import 'package:smartpost_ai/utils/custom_widgets.dart';

CustomDropdown<String>(
  value: selectedValue,
  hint: 'Choose an option',
  prefixIcon: Icons.list,
  items: [
    DropdownMenuItem(value: '1', child: Text('Option 1')),
    DropdownMenuItem(value: '2', child: Text('Option 2')),
  ],
  onChanged: (value) {
    setState(() => selectedValue = value);
  },
)
```

#### 4. Empty State Widget
```dart
import 'package:smartpost_ai/utils/custom_widgets.dart';

EmptyStateWidget(
  icon: Icons.folder_open,
  title: 'No Items Found',
  subtitle: 'Start by creating your first item',
)
```

### Using Responsive Layouts

#### Responsive Layout Builder
```dart
import 'package:smartpost_ai/utils/responsive_utils.dart';

ResponsiveLayout(
  mobile: _buildMobileView(),
  tablet: _buildTabletView(),
  desktop: _buildDesktopView(),
)
```

#### Responsive Helper Methods
```dart
import 'package:smartpost_ai/utils/responsive_utils.dart';

// Check device type
if (Responsive.isMobile(context)) {
  // Mobile-specific code
} else if (Responsive.isTablet(context)) {
  // Tablet-specific code
} else {
  // Desktop-specific code
}

// Get screen dimensions
double width = Responsive.getWidth(context);
double height = Responsive.getHeight(context);
```

#### Max Width Container
```dart
import 'package:smartpost_ai/utils/responsive_utils.dart';

MaxWidthContainer(
  maxWidth: 1200,
  child: YourContent(),
)
```

#### Responsive Padding
```dart
import 'package:smartpost_ai/utils/responsive_utils.dart';

ResponsivePadding(
  child: YourContent(),
)
// Automatically applies: 48px (desktop), 32px (tablet), 16px (mobile)
```

## 🎨 Using Colors

```dart
import 'package:smartpost_ai/values/colors.dart' as app_colors;

Container(
  color: app_colors.primaryColor,
  child: Text(
    'Hello',
    style: TextStyle(color: app_colors.textWhite),
  ),
)

// Using gradients
Container(
  decoration: BoxDecoration(
    gradient: app_colors.primaryGradient,
    borderRadius: BorderRadius.circular(12),
  ),
)
```

## 🎯 Common Patterns

### 1. Section Header with Icon Badge
```dart
Row(
  children: [
    Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: app_colors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.settings,
        color: app_colors.primaryColor,
        size: 20,
      ),
    ),
    const SizedBox(width: 12),
    const Text(
      'Section Title',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: app_colors.textPrimary,
      ),
    ),
  ],
)
```

### 2. Info Banner
```dart
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: app_colors.infoColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: app_colors.infoColor.withOpacity(0.3)),
  ),
  child: Row(
    children: [
      Icon(Icons.info_outline, color: app_colors.infoColor),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          'Important information here',
          style: TextStyle(color: app_colors.textPrimary),
        ),
      ),
    ],
  ),
)
```

### 3. Loading State
```dart
Center(
  child: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(app_colors.primaryColor),
  ),
)
```

### 4. Success Snackbar
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Row(
      children: [
        Icon(Icons.check_circle, color: app_colors.white),
        SizedBox(width: 12),
        Text('Success message'),
      ],
    ),
    backgroundColor: app_colors.successColor,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
)
```

## 📱 Screen Templates

### Basic Screen Template
```dart
import 'package:flutter/material.dart';
import 'package:smartpost_ai/utils/custom_widgets.dart';
import 'package:smartpost_ai/utils/responsive_utils.dart';
import 'package:smartpost_ai/values/colors.dart' as app_colors;

class MyNewScreen extends StatefulWidget {
  const MyNewScreen({super.key});

  @override
  State<MyNewScreen> createState() => _MyNewScreenState();
}

class _MyNewScreenState extends State<MyNewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_colors.bgSecondary,
      appBar: AppBar(
        title: const Text('Screen Title'),
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: MaxWidthContainer(
        maxWidth: 900,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      child: MaxWidthContainer(
        maxWidth: 1200,
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return CustomCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text('Your content here'),
        ],
      ),
    );
  }
}
```

## 🔧 Configuration

### Firebase Setup
Update Firestore collections:
- `currentGeminiApiKey` - Contains the active Gemini API key
- `currentHfApiKey` - Contains the active Hugging Face API key
- `huggingFaceApiKeys` - List of available API keys

Document structure:
```json
{
  "apiKey": "your-api-key-here"
}
```

### Constants Configuration
Edit `lib/values/constant.dart` for:
- API keys (fallback values)
- Breakpoints
- Other app constants

## 🎯 Best Practices

1. **Always import colors with alias**
   ```dart
   import 'package:smartpost_ai/values/colors.dart' as app_colors;
   ```

2. **Use responsive layouts for all screens**
   - Provide mobile, tablet, and desktop variants
   - Test on different screen sizes

3. **Follow the card pattern for sections**
   - Wrap major sections in CustomCard
   - Use consistent padding (24px)

4. **Use icon badges for section headers**
   - Makes UI more visual and engaging
   - Helps users identify sections quickly

5. **Provide loading and empty states**
   - Always show loading indicators for async operations
   - Use EmptyStateWidget for no-content scenarios

6. **Keep consistent spacing**
   - Use multiples of 4px (4, 8, 12, 16, 24, 32, 48)
   - Maintain vertical rhythm

## 🐛 Troubleshooting

### Common Issues

1. **Colors not showing correctly**
   - Ensure you imported colors with `as app_colors` alias
   - Check if you're using the correct color constant

2. **Responsive layout not working**
   - Verify breakpoints in `constant.dart`
   - Test with actual devices or browser dev tools

3. **Firebase connection issues**
   - Check Firebase configuration
   - Verify API keys in Firestore

4. **Theme not applying**
   - Ensure you're using `AppTheme.lightTheme` in MaterialApp
   - Import `theme_data.dart` correctly

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Material Design 3](https://m3.material.io/)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [Gemini API Docs](https://ai.google.dev/docs)
- [Hugging Face API](https://huggingface.co/docs/api-inference)

## 💡 Tips for Development

1. **Hot Reload**: Use `r` in terminal for hot reload during development
2. **Hot Restart**: Use `R` for full restart
3. **DevTools**: Use Flutter DevTools for debugging and performance
4. **Web Debug**: Open Chrome DevTools for web-specific debugging

## 🎨 Customization

### Changing Primary Color
1. Open `lib/values/colors.dart`
2. Update `primaryColor`, `primaryDark`, and `primaryLight`
3. Hot reload to see changes

### Adding New Custom Widget
1. Create in `lib/utils/custom_widgets.dart`
2. Follow existing widget patterns
3. Use color constants
4. Make it responsive if needed

### Creating New Screen
1. Create file in appropriate `features/` folder
2. Use screen template above
3. Implement responsive layouts
4. Add to routes if needed

---

**Happy Coding!** 🚀
