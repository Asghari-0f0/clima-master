import 'package:clima/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'language_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return MaterialApp(
      locale: languageProvider.currentLocale,
      supportedLocales: const [
        Locale('en'),
        Locale('fa'),
        Locale('ps'),
        Locale('zh'),
        Locale('tr'),
        Locale('de'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Clima',
      theme: ThemeData.dark(),
      home: const Home(),
    );
  }
}
