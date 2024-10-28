import 'package:currency/resultcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'currency_controller.dart';

class CurrencyConverterScreen extends StatefulWidget {
  CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final CurrencyController currencyController = Get.put(CurrencyController());

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Currency to PKR Converter',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: h * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Select Currency',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.teal[800],
                    ),
                  ),

                  // Dropdown for selecting currency
                  Obx(() => SizedBox(
                        width: w * 0.35,
                        height:  h * 0.07,
                        child: DropdownButton<String>(
                          alignment: Alignment.center,
                          dropdownColor: Colors.white,
                          iconEnabledColor: Colors.teal,
                          iconSize: 28,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          elevation: 16,
                          value: currencyController.selectedCurrency.value,
                          items: currencyController.currencyData.keys
                              .map((String currency) {
                            return DropdownMenuItem<String>(
                              value: currency,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    fit: BoxFit.fitWidth,
                                    currencyController
                                        .currencyData[currency]!['flag']!,
                                    width: w * 0.04, // Adjust size as needed
                                    height: h * 0.04, // Adjust size as needed
                                  ),
                                  SizedBox(
                                      width: w *
                                          0.03), // Space between the flag and the text
                                  Text(currency),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            currencyController.selectedCurrency.value =
                                newValue!;
                          },
                        ),
                      )),
                ],
              ),

              SizedBox(height: h * 0.02),

              // TextFormField for amount entry
              Obx(() => TextFormField(
                    controller: currencyController.amountController,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.teal,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    decoration: InputDecoration(
                      labelText:
                          'Enter amount in ${currencyController.selectedCurrency.value}',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money,
                          color: Colors.teal, size: 25),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.teal, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.teal, width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    onChanged: (value) {
                      currencyController.usdAmount.value =
                          double.tryParse(value) ?? 0.0;
                    },
                  )),

              SizedBox(height: h * 0.02),
              Obx(() => currencyController.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.teal,
                    ))
                  : SizedBox(
                      height: h * 0.06,
                      width: w * 0.9,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        onPressed: () {
                          if (currencyController
                              .amountController.value.text.isEmpty) {
                            Get.snackbar("Alert", "Kindly Enter Amount");
                          } else {
                            currencyController.convertCurrency(context);
                          }
                        },
                        child: const Text(
                          'Convert to PKR',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                      ),
                    )),

              SizedBox(height: h * 0.02),
              Obx(() => currencyController.pkrValue.value > 0
                  ? Column(
                      children: [
                        ResultCard(
                          title: 'Date',
                          value: currencyController.currentdate.value,
                          icon: Icons.calendar_view_month_sharp,
                        ),
                        SizedBox(height: h * 0.01),
                        ResultCard(
                          title:
                              '1 ${currencyController.selectedCurrency.value} to PKR Value',
                          value: currencyController.ToPkrRate.value
                              .toStringAsFixed(2),
                          icon: Icons.mode_standby_sharp,
                        ),
                        SizedBox(height: h * 0.01),
                        ResultCard(
                          title: 'Entered Amount',
                          value: currencyController.usdAmount.value
                              .toStringAsFixed(2),
                          icon: Icons.conveyor_belt,
                        ),
                        SizedBox(height: h * 0.01),
                        ResultCard(
                          title: 'Converted to PKR',
                          value: currencyController.pkrValue.value
                              .toStringAsFixed(2),
                          icon: Icons.currency_exchange,
                        ),
                        SizedBox(height: h * 0.01),
                        ResultCard(
                          title: '80% of PKR',
                          value: currencyController.pkrEightyPercent.value
                              .toStringAsFixed(2),
                          icon: Icons.percent,
                        ),
                        SizedBox(height: h * 0.01),
                        ResultCard(
                          title: '20% of PKR',
                          value: currencyController.pkrTwentyPercent.value
                              .toStringAsFixed(2),
                          icon: Icons.percent,
                        ),
                      ],
                    )
                  : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
