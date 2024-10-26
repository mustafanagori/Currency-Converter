import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternetConnectionDialog {
  static void show() {
    Get.defaultDialog(
      title: "Check Connection",
      titleStyle: const TextStyle(color: Colors.black54),
      content: Column(
        children: [
          const Icon(
            Icons.cloud_off,
            color: Colors.teal,
            size: 40,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(
                child: Text(
              "we are unable to show the result \n Kindly check Internet connection",
              textAlign: TextAlign.center,
            )),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }
}
