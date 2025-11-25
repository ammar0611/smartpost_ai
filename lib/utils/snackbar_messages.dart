import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../values/assets.dart';
import '../values/colors.dart';
import 'helper.dart';

class SnackBarMsg {
  static void showSuccessMessage(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            SvgPicture.asset(DefaultAssets.success), // Make sure to provide the correct image path
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                message!,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: transparent,
      elevation: 0,
    ));
  }

  static void showWarningMessages(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            SvgPicture.asset(DefaultAssets.error), // Make sure to provide the correct image path
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16, color: white),
              ),
            ),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: transparent,
      elevation: 0,
    ));
  }

  static void showErrorMessage(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            SvgPicture.asset(DefaultAssets.error),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                message!,
                style: const TextStyle(fontSize: 16, color: white),
              ),
            ),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: transparent,
      elevation: 0,
    ));
  }

  static void showError(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            SvgPicture.asset(DefaultAssets.error),
            // Make sure to provide the correct image path
            const SizedBox(
              width: 10,
            ),
            const Expanded(
              child: Text(
                'Error Occurred, Please try again later',
                style: TextStyle(fontSize: 16, color: white),
              ),
            ),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: transparent,
      elevation: 0,
    ));
  }

  static void noInternet(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Container(
        padding: const EdgeInsets.all(16),
        height: 60,
        decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          children: [
            Image.asset(DefaultAssets.noInternet), // Make sure to provide the correct image path
            const SizedBox(
              width: 10,
            ),
            const Text(
              'No internet connection',
              style: TextStyle(fontSize: 16, color: white),
            ),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: transparent,
      elevation: 0,
    ));
  }
}
