import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kmel_bishara_app/authPage.dart';
import 'package:kmel_bishara_app/firestoreClient.dart';
import 'package:kmel_bishara_app/globalConfig.dart';
import 'HomePage.dart';
import 'CostumerDetails.dart';
import 'loading.dart';
import 'firebase_options.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  tz.initializeTimeZones();

  // Get Application Version Update Info
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  Map<String, dynamic> appUpdates = await fsc.getAppUpdateInfo(packageInfo.version);
  bool isPlatUpdate = (Platform.isAndroid && appUpdates['android']) || (Platform.isIOS && appUpdates['ios']);
  bool isUpdateInfoEmpty = (appUpdates['title'] == null) || (appUpdates['title'] == '')
      || (appUpdates['content'] == null) || (appUpdates['content'] == '');

  // Get enabled Mondays and fridays
  globalConfig.enabledMondayDates = await fsc.getRelevantEnabledMonday();
  globalConfig.enabledFridayDates = await fsc.getRelevantEnabledFriday();

  // Start App
  if (isPlatUpdate && !isUpdateInfoEmpty) {
    // Update app screen
    runApp(MaterialApp(
      home: UpdateScreen(title: appUpdates['title']!,content: appUpdates['content']! ),
      routes: {
        //routes between app pages
        '/home' : (context) => UpdateScreen(title: appUpdates['title']!,content: appUpdates['content']! ),
      },
    ));
  } else {
    runApp(MaterialApp(
      home: AuthPage(),
      routes: {
        //routes between app pages
        '/home' : (context) => AuthPage(),
        '/homePage' : (context) => HomePage(),
        '/fill_details' : (context) => CostumerDet(),
        '/load' : (context) => LoadingScreen(),
      },
    ));
  }

}

class UpdateScreen extends StatelessWidget {
  final String title, content; // URL for App Store or Play Store

  UpdateScreen({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
            title,
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Card(
                shadowColor: Colors.black,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MediaQuery
                      .of(context)
                      .size
                      .width * 0.015),
                ),
                child: Center(
                  child: Text(
                    content,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


