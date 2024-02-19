import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      color: const Color(0xDBF14D6E),
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xDBF14D6E),
      ),
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
