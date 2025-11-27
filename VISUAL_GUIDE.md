# SmartPost AI - Visual Design Guide

## 📐 Layout Specifications

### Screen Layouts

#### Mobile Layout (< 800px)
```
┌─────────────────────────┐
│      AppBar (56px)      │
├─────────────────────────┤
│                         │
│   Header Card           │
│   (Icon + Title)        │
│                         │
├─────────────────────────┤
│                         │
│   Input Section Card    │
│   - Model Dropdown      │
│   - Prompt TextArea     │
│   - Generate Button     │
│                         │
├─────────────────────────┤
│                         │
│   Results Section       │
│   - Generated Text      │
│   - Generated Image     │
│                         │
└─────────────────────────┘

Padding: 16px
Card Border Radius: 16px
Section Spacing: 24px
```

#### Desktop Layout (> 1000px)
```
┌────────────────────────────────────────────────────────┐
│                  AppBar (64px)                         │
├────────────────────────────────────────────────────────┤
│                                                        │
│              Header Card (Full Width)                  │
│           Icon Badge + Title + Description             │
│                                                        │
├──────────────────────┬─────────────────────────────────┤
│                      │                                 │
│  Input Section (40%) │   Results Section (60%)         │
│                      │                                 │
│  - Model Dropdown    │   - Generated Text Card         │
│  - Prompt Area       │   - Generated Image Card        │
│  - Generate Button   │   - Action Buttons              │
│                      │                                 │
│                      │                                 │
└──────────────────────┴─────────────────────────────────┘

Max Width: 1400px
Padding: 48px
Column Gap: 32px
```

---

## 🎨 Component Specifications

### 1. Gradient Button
```
┌────────────────────────────────────┐
│  [Icon]  Button Text               │  Height: 56px
└────────────────────────────────────┘
   8px    16px padding

Background: Linear Gradient (Primary → Primary Light)
Border Radius: 12px
Shadow: 0px 4px 12px rgba(108, 99, 255, 0.3)
Text: White, 16px, Semi-bold
Icon Size: 20px
```

### 2. Custom Card
```
┌──────────────────────────────────┐
│  Content Area                    │
│  Padding: 24px                   │
│                                  │
│  Background: White               │
│  Border Radius: 16px            │
│  Shadow: 0px 2px 10px rgba(0,0,0,0.05)
└──────────────────────────────────┘
```

### 3. Section Header with Icon Badge
```
┌───┐
│ ✨ │  Section Title           Badge Size: 40x40px
└───┘  Font: 18px, Bold         Icon: 20px
 12px                            Border Radius: 8px
                                 Background: Primary 10%
```

### 4. Input Field
```
┌────────────────────────────────────┐
│  Placeholder text...               │  Height: 56px (single)
└────────────────────────────────────┘  Height: Auto (multi)

Background: Grey 100
Border: 1px Grey 300
Border (Focus): 2px Primary
Border Radius: 12px
Padding: 16px
Font Size: 14px
```

### 5. Dropdown
```
┌────────────────────────────────────┐
│ [Icon]  Selected Value      [▼]   │  Height: 56px
└────────────────────────────────────┘

Icon Size: 20px
Icon Color: Text Secondary
Padding: 16px horizontal, 12px vertical
Border Radius: 12px
```

---

## 📏 Spacing System

### Padding & Margins
```
4px   - Minimal spacing
8px   - Small spacing
12px  - Compact spacing
16px  - Default spacing (Mobile)
20px  - Medium spacing
24px  - Section spacing
32px  - Large spacing (Tablet)
48px  - Extra large (Desktop)
```

### Common Patterns
```
Mobile:
- Screen padding: 16px
- Card padding: 20-24px
- Element spacing: 16-24px

Tablet:
- Screen padding: 32px
- Card padding: 24px
- Element spacing: 24-32px

Desktop:
- Screen padding: 48px
- Card padding: 24-32px
- Element spacing: 32-48px
```

---

## 🔤 Typography Scale

### Heading Sizes
```
Display Large:    32px / Bold      (Main titles)
Display Medium:   28px / Bold      (Section titles)
Display Small:    24px / Bold      (Subsection titles)
Headline Medium:  20px / Semi-bold (Card headers)
Title Large:      18px / Semi-bold (Section headers)
Title Medium:     16px / Medium    (Labels)
```

### Body Text
```
Body Large:       16px / Regular   (Main content)
Body Medium:      14px / Regular   (Secondary content)
Body Small:       12px / Regular   (Captions, helpers)
```

### Line Heights
```
Headings:  1.2 - 1.3
Body Text: 1.5 - 1.6
Captions:  1.4
```

---

## 🎨 Shadow Definitions

### Card Shadow
```
Elevation: 2
X: 0px
Y: 2px
Blur: 10px
Color: rgba(0, 0, 0, 0.05)

CSS: box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.05);
```

### Button Shadow
```
X: 0px
Y: 4px
Blur: 12px
Color: rgba(108, 99, 255, 0.3)

CSS: box-shadow: 0px 4px 12px rgba(108, 99, 255, 0.3);
```

### Hover Effect Shadow
```
X: 0px
Y: 6px
Blur: 16px
Color: rgba(108, 99, 255, 0.4)
```

---

## 🎯 Interactive States

### Button States
```
Normal:
- Background: Gradient
- Shadow: 4px blur 12px
- Cursor: pointer

Hover:
- Background: Slightly darker gradient
- Shadow: 6px blur 16px
- Cursor: pointer

Pressed:
- Background: Even darker
- Shadow: 2px blur 8px
- Transform: scale(0.98)

Disabled:
- Background: Grey 300
- Shadow: none
- Cursor: not-allowed
- Opacity: 0.6
```

### Input States
```
Normal:
- Border: 1px Grey 300
- Background: Grey 100

Focus:
- Border: 2px Primary
- Background: White
- Shadow: 0px 0px 0px 3px Primary (10% opacity)

Error:
- Border: 1px Error Color
- Background: Error (5% opacity)
```

---

## 📱 Touch Targets

### Minimum Sizes
```
Buttons:      48x48px minimum (56px recommended)
Icons:        44x44px minimum
Text Links:   32px height minimum
Checkboxes:   24x24px minimum
Radio Buttons: 24x24px minimum
```

---

## 🎨 Icon System

### Icon Sizes
```
Extra Small:  16px
Small:        20px
Medium:       24px (default)
Large:        32px
Extra Large:  48px
Hero:         64px
```

### Icon Colors
```
Primary:      Text Primary (#2D3748)
Secondary:    Text Secondary (#718096)
Disabled:     Text Light (#A0AEC0)
Brand:        Primary Color (#6C63FF)
Accent:       Accent Color (#FF6584)
Success:      Success Color (#48BB78)
Error:        Error Color (#F56565)
```

### Icon Badge Pattern
```
┌────────┐
│        │
│   🎨   │   Size: 40x40px
│        │   Icon: 20px
└────────┘   Padding: 8px
             Border Radius: 8px
             Background: Color (10% opacity)
```

---

## 🎯 Common Layout Patterns

### Card with Header
```
┌──────────────────────────────────┐
│ [🎨]  Header Title               │
├──────────────────────────────────┤
│                                  │
│  Content area with padding       │
│                                  │
└──────────────────────────────────┘

Header Padding: 20px
Content Padding: 24px
Border Between: 1px Grey 200
```

### Info Banner
```
┌──────────────────────────────────┐
│ [ℹ️]  Information message        │
└──────────────────────────────────┘

Background: Info Color (10% opacity)
Border: 1px Info Color (30% opacity)
Border Radius: 12px
Padding: 16px
Icon Size: 20px
Gap: 12px
```

### Result Card
```
┌──────────────────────────────────┐
│ [📝]  Result Title    [📋 Copy]  │
├──────────────────────────────────┤
│                                  │
│  ╔════════════════════════════╗  │
│  ║ Result content displayed   ║  │
│  ║ in styled container        ║  │
│  ╚════════════════════════════╝  │
│                                  │
└──────────────────────────────────┘

Inner Container:
  Background: Grey 100
  Border: 1px Grey 300
  Border Radius: 12px
  Padding: 16px
```

---

## 🎨 Loading States

### Loading Indicator
```
  ╭───╮
  │ ○ │   Size: 24px (button)
  ╰───╯   Size: 40px (page)
          Color: Primary / White
          Stroke Width: 2.5px
```

### Loading Overlay
```
┌────────────────────────────────┐
│                                │
│                                │
│         ╭───────╮              │
│         │   ○   │              │
│         ╰───────╯              │
│                                │
│                                │
└────────────────────────────────┘

Background: Black (30% opacity)
Indicator Container:
  Background: White
  Padding: 32px
  Border Radius: 16px
```

---

## 🎯 Empty States

```
         ╭─────╮
         │     │
         │  📁 │    Icon Size: 64px
         │     │    Icon Color: Grey 500
         ╰─────╯
        
    No Content Yet         Font: 20px, Semi-bold
                           Color: Text Primary
        
  Your content will        Font: 14px
  appear here             Color: Text Secondary

Circle Background:
  Size: 120px diameter
  Background: Grey 100
  Padding: 24px
```

---

## 📐 Border Radius System

```
Small:      8px   (badges, small buttons)
Medium:     12px  (inputs, regular buttons)
Large:      16px  (cards, major containers)
Extra Large: 20px  (hero sections)
Circle:     50%   (avatar, icon circles)
```

---

## 🎨 Animation Specs

### Transitions
```
Fast:        150ms  (hover, focus)
Medium:      250ms  (modals, drawers)
Slow:        350ms  (page transitions)

Easing:      cubic-bezier(0.4, 0.0, 0.2, 1)
```

### Common Animations
```
Fade In:     opacity 0 → 1 (250ms)
Slide Up:    translateY(20px) → 0 (250ms)
Scale:       scale(0.95) → 1 (200ms)
Rotate:      rotate(0) → 360deg (500ms)
```

---

## 📱 Responsive Image Specifications

### Hero Images
```
Mobile:    375w x 250h   (ratio 3:2)
Tablet:    768w x 512h   (ratio 3:2)
Desktop:   1200w x 800h  (ratio 3:2)
```

### Generated Images
```
Display:   100% width
Max Width: 800px
Border Radius: 12px
Object Fit: cover
```

---

## ✅ Accessibility Checklist

- [ ] Color contrast meets WCAG AA (4.5:1)
- [ ] Touch targets minimum 48x48px
- [ ] Focus indicators visible
- [ ] Alt text for images
- [ ] Keyboard navigation supported
- [ ] Screen reader labels present
- [ ] Error messages descriptive
- [ ] Form inputs labeled
- [ ] Skip navigation available
- [ ] Responsive text sizing

---

**SmartPost AI Design Specifications** 📐
*Precise guidelines for implementation*
