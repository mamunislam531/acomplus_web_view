import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonSnackBarMessage {
  static noInternetConnection() {
    Get.snackbar("You are Offline !!", "Please check internet connection.",
        backgroundColor: Colors.red.shade50, colorText: Colors.red, snackPosition: SnackPosition.TOP);
  }

  static errorMessage({String? title, required String text}) {
    Get.snackbar(title ?? "Message", text, backgroundColor: Colors.white, colorText: Colors.red, snackPosition: SnackPosition.TOP);
  }
}
