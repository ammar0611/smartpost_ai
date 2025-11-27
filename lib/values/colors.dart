import 'package:flutter/material.dart';

// Primary Brand Colors
const Color primaryColor = Color(0xFF6C63FF);
const Color primaryDark = Color(0xFF5145E5);
const Color primaryLight = Color(0xFF8F88FF);

// Secondary Colors
const Color secondaryColor = Color(0xFF00D9FF);
const Color accentColor = Color(0xFFFF6584);

// Background Colors
const Color bgPrimary = Color(0xFFFFFFFF);
const Color bgSecondary = Color(0xFFF8F9FA);
const Color bgDark = Color(0xFF1A1A2E);
const Color bgCard = Color(0xFFFFFFFF);

// Text Colors
const Color textPrimary = Color(0xFF2D3748);
const Color textSecondary = Color(0xFF718096);
const Color textLight = Color(0xFFA0AEC0);
const Color textWhite = Color(0xFFFFFFFF);

// Functional Colors
const Color successColor = Color(0xFF48BB78);
const Color warningColor = Color(0xFFFBD38D);
const Color errorColor = Color(0xFFF56565);
const Color infoColor = Color(0xFF4299E1);

// Neutral Colors
const Color white = Color(0xFFFFFFFF);
const Color black = Color(0xFF000000);
const Color transparent = Color(0x00ffffff);
const Color grey100 = Color(0xFFF7FAFC);
const Color grey200 = Color(0xFFEDF2F7);
const Color grey300 = Color(0xFFE2E8F0);
const Color grey400 = Color(0xFFCBD5E0);
const Color grey500 = Color(0xFFA0AEC0);
const Color grey600 = Color(0xFF718096);
const Color grey700 = Color(0xFF4A5568);
const Color grey800 = Color(0xFF2D3748);
const Color grey900 = Color(0xFF1A202C);

// Gradient Colors
const LinearGradient primaryGradient = LinearGradient(
  colors: [primaryColor, primaryLight],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient accentGradient = LinearGradient(
  colors: [secondaryColor, primaryColor],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);