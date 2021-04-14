import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:studily/calendar_client.dart';
import 'package:studily/secrets.dart';
import 'package:studily/welcome/welcome.dart';

import 'package:studily/homescreen/home_body.dart';
import 'package:studily/calendar_client.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'dart:io' show Platform, exit;

import 'dart:io';
import 'dart:async';

Future<void> main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var _clientID = new ClientId(Secret.getId(), "");
  const _scopes = const [cal.CalendarApi.calendarScope];
  await clientViaUserConsent(_clientID, _scopes, prompt)
      .then((AuthClient client) async {
    CalendarClient.calendar = cal.CalendarApi(client);
  });

  runApp(MyApp());
}

void prompt(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Studily',
      home: WelcomeScreen(),

      // routes: routes,
    );
  }
}
