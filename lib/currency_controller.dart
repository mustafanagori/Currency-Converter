import 'dart:async';
import 'package:currency/internet_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CurrencyController extends GetxController {
  final TextEditingController amountController = TextEditingController();
  RxDouble usdAmount = 0.0.obs;
  RxDouble pkrValue = 0.0.obs;
  RxDouble pkrEightyPercent = 0.0.obs;
  RxDouble pkrTwentyPercent = 0.0.obs;
  RxDouble ToPkrRate = 0.0.obs;
  RxBool isLoading = false.obs;
  RxString currentdate = ''.obs;
  RxString selectedCurrency = 'USD'.obs;

  final Map<String, Map<String, String>> currencyData = {
    'USD': {
      'url': 'https://api.exchangerate-api.com/v4/latest/USD',
      'flag': 'assets/usd.svg', // Local flag asset for USD
    },
    'EUR': {
      'url': 'https://api.exchangerate-api.com/v4/latest/EUR',
      'flag': 'assets/euro.svg', // Local flag asset for EUR
    },
    'AUD': {
      'url': 'https://api.exchangerate-api.com/v4/latest/AUD',
      'flag': 'assets/aus.svg', // Local flag asset for AUD
    },
    'GBP': {
      'url': 'https://api.exchangerate-api.com/v4/latest/GBP',
      'flag': 'assets/gbp.svg', // Local flag asset for GBP
    },
    'CAD': {
      'url': 'https://api.exchangerate-api.com/v4/latest/CAD',
      'flag': 'assets/can.svg', // Local flag asset for CAD
    },
  };

  Future<void> convertCurrency(BuildContext context) async {
    print(amountController.value.text.runtimeType);

    double? parsedValue = double.tryParse(amountController.value.text);
    if (parsedValue != null) {
      RxDouble convertFieldValue =
          parsedValue.obs; // Make it an observable double
      print(convertFieldValue.value.runtimeType); // This should now be 'double'
    } else {
      print("The text is not a valid double");
    }

    FocusScope.of(context).unfocus();
    if (usdAmount.value <= 0) {
      Get.snackbar("Invalid Input", "Enter a valid amount");
      return;
    }

    bool isConnected = await InternetConnectionChecker().hasConnection;
    if (!isConnected) {
      InternetConnectionDialog.show();
      return;
    }

    isLoading.value = true;
    String apiUrl = currencyData[selectedCurrency.value]?['url'] ?? '';

    try {
      final response =
          await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        ToPkrRate.value = (data['rates']['PKR'] as num).toDouble();
        currentdate.value = data['date'];
        pkrValue.value = parsedValue! * ToPkrRate.value;
        pkrEightyPercent.value = pkrValue.value * 0.8;
        pkrTwentyPercent.value = pkrValue.value * 0.2;
      } else {
        Get.snackbar("Error", "Failed to fetch exchange rate. Try again.");
      }
    } catch (e) {
      if (e is TimeoutException) {
        InternetConnectionDialog.show();
      } else {
        Get.snackbar("Error", "Something went wrong: ${e.toString()}");
      }
    } finally {
      isLoading.value = false;
      amountController.clear();
    }
  }

  void resetConversion() {
    pkrValue.value = 0.0;
    pkrEightyPercent.value = 0.0;
    ToPkrRate.value = 0.0;
    currentdate.value = '';
  }
}
