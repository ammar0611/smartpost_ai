import 'package:flutter/material.dart';
import 'package:smartpost_ai/values/constant.dart';

/// Responsive layout builder that adapts to different screen sizes
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Constant.breakPoint_1000) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= Constant.breakPoint_800) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// Helper class to check device type
class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < Constant.breakPoint_800;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= Constant.breakPoint_800 &&
      MediaQuery.of(context).size.width < Constant.breakPoint_1000;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= Constant.breakPoint_1000;

  static double getWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
}

/// Responsive padding that adapts to screen size
class ResponsivePadding extends StatelessWidget {
  final Widget child;

  const ResponsivePadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double padding;

    if (width >= Constant.breakPoint_1000) {
      padding = 48.0;
    } else if (width >= Constant.breakPoint_800) {
      padding = 32.0;
    } else {
      padding = 16.0;
    }

    return Padding(
      padding: EdgeInsets.all(padding),
      child: child,
    );
  }
}

/// Max width container for web layouts
class MaxWidthContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const MaxWidthContainer({
    super.key,
    required this.child,
    this.maxWidth = 1200,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
