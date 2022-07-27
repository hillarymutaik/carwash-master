import 'package:carwash/screens/Drawer/selectLanguage/selectLanguage.dart';
import 'package:carwash/style/style.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mpesa_flutter_plugin/initializer.dart';
import 'backend/notification.dart';
import 'language/languageCubit.dart';
import 'language/locale.dart';
import 'map_utils.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'backend/local_notification_service.dart';

void main() async {
  print("initializing firebase...");
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();

  MpesaFlutterPlugin.setConsumerKey("Azs2KejU1ARvIL5JdJsARbV2gDrWmpOB");
  MpesaFlutterPlugin.setConsumerSecret("hipGvFJbOxri330c");

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  MapUtils.getMarkerPic();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

///Receive message when app is in background solution for on message
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
  LocalNotificationService.display(message);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NotificationClass().init(context);
    NotificationClass().aacessRegistrationToken();
    {
      return BlocProvider<LanguageCubit>(
        create: (context) => LanguageCubit(),
        child: BlocBuilder<LanguageCubit, Locale>(
          builder: (_, locale) {
            return GetMaterialApp(
              localizationsDelegates: [
                const AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en'),
                const Locale('ar'),
                const Locale('pt'),
                const Locale('fr'),
                const Locale('id'),
                const Locale('es'),
                const Locale('tr'),
                const Locale('it'),
                const Locale('sw'),
              ],
              locale: locale,
              theme: uiTheme(),
              home: SelectLanguage(true),
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      );
    }
  }
}
