import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'src/app/bindings/initial_bindings.dart';
import 'src/app/routes/routes.dart';
import 'src/app/routes/routes_handler.dart';
import 'src/common/controller/theme_controller/theme_controller.dart';
import 'src/presentation/screen/no_internet/controller/connectivity_controller.dart';
import 'src/presentation/screen/no_internet/view/no_internet_screen.dart';
import 'src/services/fcm_token_stored_service.dart';
import 'src/services/translation_service.dart';
import 'src/utils/constants/app_strings.dart';
import 'src/utils/theme/app_theme.dart';

import 'src/services/firebase_messagaging_service.dart';
import 'src/services/local_notification_service.dart';

void main() async {
  await _initializeServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController(), permanent: true);

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        initialBinding: InitialBindings(),
        themeMode: themeController.themeMode.value,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        getPages: routesHandler,
        initialRoute: BaseRoute.splash,
        builder: (context, child) {
          return Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) => ScreenUtilInit(
                  designSize: const Size(376, 812),
                  minTextAdapt: true,
                  splitScreenMode: true,
                  child: GetX<ConnectivityController>(
                    builder: (controller) {
                      return Stack(
                        children: [
                          child!,
                          if (controller.isOffline.value)
                            const NoInternetScreen(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Future<void> _initializeServices() async {
  WidgetsFlutterBinding.ensureInitialized();

  // UI text must be available before the first widget is rendered. Remote
  // language data is applied later as an override by LanguageController.
  await TranslationService().loadBundledTranslations();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.lazyPut<FcmTokenStoredService>(() => FcmTokenStoredService());

  // Initialize local notifications
  await LocalNotificationsService.instance().init();

  // Initialize Firebase messaging
  await FirebaseMessagingService.instance().init(
    localNotificationsService: LocalNotificationsService.instance(),
  );
}
