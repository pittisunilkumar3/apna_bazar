import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:listplace/controllers/bindings/bindings.dart';
import 'package:listplace/routes/routes_helper.dart';
import 'package:listplace/routes/routes_name.dart';
import 'package:listplace/themes/themes.dart';
import 'controllers/app_controller.dart';
import 'notification_service/notification_service.dart';
import 'utils/app_constants.dart';
import 'utils/services/custom_error.dart';
import 'utils/services/localstorage/init_hive.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'views/widgets/time_custom_message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? 'DEFAULT_KEY';
  timeago.setLocaleMessages('en', MyCustomMessages());
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    // Force Hybrid Composition mode.
    mapsImplementation.useAndroidViewSurface = true;
  }
  await Future.wait([
    Stripe.instance.applySettings(),
    initHive(),
    LocalNotificationService().initNotification(),
    Future.delayed(const Duration(milliseconds: 300)),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Create a custom 404 error page to replace Flutter's default red error screen.
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      String errorString = errorDetails.exceptionAsString();
      String stackTrace = errorDetails.stack.toString();
      // Check if the error involves GetBuilder
      if (errorString.contains('GetBuilder') ||
          stackTrace.contains('GetBuilder') ||
          errorString.contains('Scaffold')) {
            
        return CustomError(errorDetails: errorDetails);
      } else {
        // Use the default error widget for other cases
        return kDebugMode
            ? ErrorWidget(errorDetails.exception)
            : Center(
                child: Image.asset(
                  '$rootImageDir/404.png',
                  height: 120.h,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              );
      }
    };
    return ScreenUtilInit(
        designSize: const Size(430, 892),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            initialBinding: InitBindings(),
            themeMode: Get.put(AppController()).themeManager(),
            initialRoute: RoutesName.INITIAL,
            getPages: RouteHelper.routes(),
            builder: (BuildContext context, Widget? widget) {
              return widget ?? Container(child: Text("Widget is null"));
            },
          );
        });
  }
}
