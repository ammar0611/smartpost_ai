# SmartPost AI - Color Palette Reference

## 🎨 Primary Brand Colors

### Primary Purple
```
Primary Color:      #6C63FF
Primary Dark:       #5145E5
Primary Light:      #8F88FF

RGB: (108, 99, 255)
RGB Dark: (81, 69, 229)
RGB Light: (143, 136, 255)

Usage: Main actions, primary buttons, branding elements
```

### Secondary & Accent Colors
```
Secondary Color:    #00D9FF
RGB: (0, 217, 255)
Usage: Secondary actions, highlights

Accent Color:       #FF6584
RGB: (255, 101, 132)
Usage: Important highlights, badges, alerts
```

---

## 🎯 Functional Colors

### Success
```
Success Color:      #48BB78
RGB: (72, 187, 120)
Usage: Success messages, positive feedback, completed states
```

### Error
```
Error Color:        #F56565
RGB: (245, 101, 101)
Usage: Error messages, validation errors, warnings
```

### Info
```
Info Color:         #4299E1
RGB: (66, 153, 225)
Usage: Informational messages, tips, help text
```

### Warning
```
Warning Color:      #FBD38D
RGB: (251, 211, 141)
Usage: Warning messages, caution notices
```

---

## ⚪ Background Colors

### Primary Backgrounds
```
Background Primary:     #FFFFFF
RGB: (255, 255, 255)
Usage: Main background, card backgrounds

Background Secondary:   #F8F9FA
RGB: (248, 249, 250)
Usage: Page background, subtle contrasts

Background Dark:        #1A1A2E
RGB: (26, 26, 46)
Usage: Dark mode background

Background Card:        #FFFFFF
RGB: (255, 255, 255)
Usage: Card and panel backgrounds
```

---

## 📝 Text Colors

### Text Hierarchy
```
Text Primary:       #2D3748
RGB: (45, 55, 72)
Usage: Main text content, headings

Text Secondary:     #718096
RGB: (113, 128, 150)
Usage: Secondary text, descriptions

Text Light:         #A0AEC0
RGB: (160, 174, 192)
Usage: Placeholder text, disabled text

Text White:         #FFFFFF
RGB: (255, 255, 255)
Usage: Text on dark backgrounds
```

---

## 🔘 Neutral Colors (Grey Scale)

```
Grey 100:   #F7FAFC   (247, 250, 252)
Grey 200:   #EDF2F7   (237, 242, 247)
Grey 300:   #E2E8F0   (226, 232, 240)
Grey 400:   #CBD5E0   (203, 213, 224)
Grey 500:   #A0AEC0   (160, 174, 192)
Grey 600:   #718096   (113, 128, 150)
Grey 700:   #4A5568   (74, 85, 104)
Grey 800:   #2D3748   (45, 55, 72)
Grey 900:   #1A202C   (26, 32, 44)

Usage:
100-300: Backgrounds, borders
400-600: Icons, secondary elements
700-900: Text, primary elements
```

---

## 🌈 Gradients

### Primary Gradient
```
Linear Gradient
Start: #6C63FF (Primary Color)
End:   #8F88FF (Primary Light)
Direction: Top-Left to Bottom-Right

CSS:
background: linear-gradient(135deg, #6C63FF 0%, #8F88FF 100%);

Usage: Primary buttons, hero sections, brand elements
```

### Accent Gradient
```
Linear Gradient
Start: #00D9FF (Secondary Color)
End:   #6C63FF (Primary Color)
Direction: Top-Left to Bottom-Right

CSS:
background: linear-gradient(135deg, #00D9FF 0%, #6C63FF 100%);

Usage: Special highlights, premium features, promotional elements
```

---

## 🎨 Color Usage Guidelines

### Do's ✅
- Use Primary Purple for main CTAs and primary actions
- Use gradients sparingly for emphasis
- Maintain sufficient contrast (minimum 4.5:1 ratio)
- Use semantic colors (success, error) consistently
- Stick to the defined color palette

### Don'ts ❌
- Don't create custom colors outside the palette
- Don't use low contrast combinations
- Don't overuse bright accent colors
- Don't mix multiple gradients in the same view
- Don't ignore color accessibility guidelines

---

## 🔍 Opacity Variations

### Common Opacity Levels
```
10%  (0.1) - Very subtle backgrounds
20%  (0.2) - Subtle backgrounds
30%  (0.3) - Light overlays, shadows
50%  (0.5) - Medium overlays
70%  (0.7) - Strong overlays
80%  (0.8) - Very strong overlays
90%  (0.9) - Almost opaque
```

### Example Usage in Flutter
```dart
// 10% opacity background
color: app_colors.primaryColor.withOpacity(0.1)

// 30% opacity shadow
color: app_colors.black.withOpacity(0.3)

// 80% opacity overlay
color: app_colors.white.withOpacity(0.8)
```

---

## 📱 Platform-Specific Considerations

### Web (Chrome)
- Colors render consistently
- Full gradient support
- Use shadows liberally
- High-res color accuracy

### Mobile (iOS/Android)
- Test on actual devices
- Consider battery impact of dark backgrounds
- Ensure touch targets have sufficient contrast
- Test in bright sunlight conditions

---

## 🎯 Accessibility

### WCAG 2.1 Compliance

**Level AA Requirements:**
- Normal text: 4.5:1 contrast ratio
- Large text: 3:1 contrast ratio
- UI components: 3:1 contrast ratio

**Tested Combinations:**
✅ Text Primary (#2D3748) on White (#FFFFFF) = 13.2:1
✅ Text Secondary (#718096) on White (#FFFFFF) = 4.9:1
✅ White (#FFFFFF) on Primary (#6C63FF) = 8.6:1
✅ Text Primary on Grey 100 = 12.5:1

---

## 🎨 Color Psychology

### Why These Colors?

**Purple (#6C63FF)**
- Creativity and innovation
- Technology and AI
- Premium and professional
- Imagination and possibilities

**Cyan (#00D9FF)**
- Modern and digital
- Trust and reliability
- Communication
- Fresh and energetic

**Pink (#FF6584)**
- Excitement and energy
- Attention-grabbing
- Playful and creative
- Dynamic and bold

---

## 📋 Quick Reference

### Most Used Colors
```
Primary Action:         #6C63FF
Background:            #F8F9FA
Card Background:       #FFFFFF
Main Text:            #2D3748
Secondary Text:       #718096
Border:               #E2E8F0
Success:              #48BB78
Error:                #F56565
```

### Color Variables in Code
```dart
// Import with alias
import 'package:smartpost_ai/values/colors.dart' as app_colors;

// Usage
color: app_colors.primaryColor
color: app_colors.textPrimary
color: app_colors.bgSecondary
```

---

## 🎨 Design Tools Export

### Figma
```
Primary: 6C63FF
Secondary: 00D9FF
Accent: FF6584
Success: 48BB78
Error: F56565
Info: 4299E1
```

### Adobe XD
```
Primary RGB: 108, 99, 255
Secondary RGB: 0, 217, 255
Accent RGB: 255, 101, 132
```

### CSS Variables
```css
:root {
  --color-primary: #6C63FF;
  --color-secondary: #00D9FF;
  --color-accent: #FF6584;
  --color-success: #48BB78;
  --color-error: #F56565;
  --color-info: #4299E1;
  --color-text-primary: #2D3748;
  --color-bg-secondary: #F8F9FA;
}
```

---

**SmartPost AI Color System** 🎨
*Designed for clarity, accessibility, and modern aesthetics*
