import 'package:flutter/material.dart';
import 'package:flutter_video_call/app/core/app_colors.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      color: AppColors.baseColor,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.baseColor,
      ),
      title: "Agora Video Call",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
