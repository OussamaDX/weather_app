import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/pages/notesPage.dart';
import 'package:weather_app/pages/weatherScreen.dart';
import 'package:weather_app/pages/welcomePage.dart';

void main() {
  runApp(
    // Wrap your app with ProviderScope to enable Riverpod
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: const Notespage(),
    );
  }
}


/*
add a app bar 
and add riverpod
and watch video of delivvety app
*/

/*
// add notes (use riverpod)
// and also gride view page 
// add sign in page 

// add ideas to kool morocco 
*/