import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    // String formattedDate = DateFormat('yMMMMd')
    //     .format(DateTime.parse(currencyController.currentdate.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'USD to PKR Converter',
          style: TextStyle(color: Colors.white , fontSize: 18),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: w * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: h * 0.01),
              Text(
                'Currency Converter',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.teal[800],
                ),
              ),
              SizedBox(height: h * 0.005),
              // Display the Dollar rate with the date
              SizedBox(height: h * 0.02),

              TextFormField(
                controller: currencyController.usdController,
                keyboardType: TextInputType.number,
                cursorColor: Colors.teal,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(
                      r'^\d*\.?\d*')), // Only allow numbers and one decimal point
                ],
                decoration: const InputDecoration(
                  labelText: 'Enter amount in USD',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                  border: OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.attach_money, color: Colors.teal, size: 25),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                onChanged: (value) {
                  currencyController.usdAmount.value =
                      double.tryParse(value) ?? 0.0;
                },
              ),

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
                          // Check if the input is empty
                          if (currencyController.usdController.text.isEmpty) {
                            Get.snackbar("Alert", "Kindly Enter Amount");
                          } else {
                            currencyController.convertCurrency(context);
                          }
                        },
                        child: const Text(
                          'Convert to PKR',
                          style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w300),
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
                          title: '1 USD to PKR Value',
                          value: currencyController.usdToPkrRate
                              .toStringAsFixed(2),
                          icon: Icons.attach_money,
                        ),
                        SizedBox(height: h * 0.01),
                        ResultCard(
                          title: 'Entered USD',
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

class ResultCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const ResultCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Card(
      color: Colors.teal[50],
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Colors.teal, size: 22),
            SizedBox(width: w * 0.05),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, color: Colors.teal[800]),
                ),
                SizedBox(height: h * 0.005),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
