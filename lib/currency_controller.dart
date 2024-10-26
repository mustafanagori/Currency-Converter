import 'dart:async';
import 'package:currency/internet_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CurrencyController extends GetxController {
  final TextEditingController usdController = TextEditingController();
  var usdAmount = 0.0.obs;
  var pkrValue = 0.0.obs;
  var pkrEightyPercent = 0.0.obs;
  var isLoading = false.obs;
  var usdToPkrRate = 0.0;
  RxString currentdate = ''.obs;

  Future<void> convertCurrency(BuildContext context) async {
     FocusScope.of(context).unfocus();
    bool isConnected = await InternetConnectionChecker().hasConnection;
    if (!isConnected) {
      InternetConnectionDialog.show();
      isLoading.value = false;
      return;
    }

    if (usdAmount.value <= 0) return; // Prevent conversion for invalid input
    isLoading.value = true;

    try {
      final response = await http
          .get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        usdToPkrRate = data['rates']['PKR'];
        currentdate.value = data['date'];

        // Convert to PKR and calculate 80% of the value
        pkrValue.value = usdAmount.value * usdToPkrRate;
        pkrEightyPercent.value = pkrValue.value * 0.8;
      } else {
        Get.snackbar("Error", "Failed to fetch exchange rate");
      }
    } catch (e) {
      if (e is TimeoutException) {
        InternetConnectionDialog.show();
      } else {
        Get.snackbar("Error", e.toString());
      }
    } finally {
      // clear();
      isLoading.value = false;
      usdController.clear();
    }
  }

  void clear() {
    usdController.clear();
    usdAmount.value = 0.0;
    pkrValue.value = 0.0;
    pkrEightyPercent.value = 0.0;
    usdToPkrRate = 0.0;
  }
}
