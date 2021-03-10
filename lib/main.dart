import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'CostumerDetails.dart';
import 'RevealAppointment.dart';
import 'loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: HomePage(),
    routes: {
      //routes between app pages
      '/home' : (context) => HomePage(),
      '/fill_details' : (context) => CostumerDet(),
      '/reveal_appointment' : (context) => Reveal(),
      '/load' : (context) => LoadingScreen(),
    },
  ));
}

