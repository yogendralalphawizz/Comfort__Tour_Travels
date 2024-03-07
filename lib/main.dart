import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quick_pay/Auth/Login/UI/login_page.dart';
import 'package:quick_pay/BottomNavigation/Home/home.dart';
import 'package:quick_pay/splash/my_test%20screen.dart';
import 'package:quick_pay/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'Auth/Login/UI/login_ui.dart';
import 'Auth/login_navigator.dart';
import 'BottomNavigation/bottom_navigation.dart';
import 'Config/firebasenotification.dart';
import 'Locale/language_cubit.dart';
import 'Locale/locales.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'Routes/routes.dart';
import 'Theme/style.dart';
NotificationClass notificationClass=NotificationClass();
Future<void> handleNotificationPermission() async {
  const permission = Permission.notification;
  final status = await permission.status;
  if (status.isGranted) {
    print('User granted this permission before');
  } else {
    final before = await permission.shouldShowRequestRationale;
    final rs = await permission.request();
    final after = await permission.shouldShowRequestRationale;

    if (rs.isGranted) {
      print('User granted notication permission');
    } else if (!before && after) {
      print('Show permission request pop-up and user denied first time');
    } else if (before && !after) {
      print('Show permission request pop-up and user denied a second time');
    } else if (!before && !after) {
      print('No more permission pop-ups displayed');
    }
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

 //await notificationClass.initNotification();
 // await Firebase.initializeApp();
 await handleNotificationPermission();

  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessageing);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    //statusBarColor: AppTheme.primaryColor, // status bar color
  ));

  runApp(
      Phoenix(
      child: BlocProvider<LanguageCubit>(
    create: (context) => LanguageCubit(),
    child: QuickPay(),
  )));
}

class QuickPay extends StatefulWidget {
  @override
  State<QuickPay> createState() => _QuickPayState();
}

class _QuickPayState extends State<QuickPay> {


  @override
  void initState() {
    notificationClass.initNotification();
    // TODO: implement initState
    // Timer(Duration(seconds: 3), () {
    //   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignInScreen()));}
    // );

    super.initState();


  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(builder: (context, appLocale) {
      return MaterialApp(
        /*localizationsDelegates: [
          const AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],*/
        /*supportedLocales: AppLocalizations.getSupportedLocales(),
        locale: appLocale,*/
        debugShowCheckedModeBanner: false,
        theme: appTheme,

        home:SplashScreen()
        // id == null ||  id == "" ? LoginNavigator() : AppNavigation(),
        // routes: PageRoutes().routes(),
      );
    });
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_phoenix/flutter_phoenix.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'Auth/login_navigator.dart';
// import 'Locale/language_cubit.dart';
// import 'Locale/locales.dart';
// import 'Routes/routes.dart';
// import 'Theme/style.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   MobileAds.instance.initialize();
//   runApp(Phoenix(
//       child: BlocProvider<LanguageCubit>(
//         create: (context) => LanguageCubit(),
//         child: QuickPay(),
//       )));
// }
// class QuickPay extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LanguageCubit, Locale>(builder: (context, appLocale) {
//       return MaterialApp(
//         localizationsDelegates: [
//           const AppLocalizationsDelegate(),
//           GlobalMaterialLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//           GlobalCupertinoLocalizations.delegate,
//         ],
//         supportedLocales: AppLocalizations.getSupportedLocales(),
//         locale: appLocale,
//         debugShowCheckedModeBanner: false,
//         theme: appTheme,
//         home: LoginNavigator(),
//         routes: PageRoutes().routes(),
//       );
//     });
//   }
// }
