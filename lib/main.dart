import 'package:flutter/material.dart';
import 'package:go_sleep/my_home_page.dart';
import 'package:go_sleep/shutdown_warning_page.dart';

void main(List<String> args) {
  for (var arg in args) {
    print('running with $arg');
  }

  bool shouldShutdown = args.contains('--shutdown');

  runApp(MyApp(shouldShutdown: shouldShutdown));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.shouldShutdown});

  final bool shouldShutdown;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget home = shouldShutdown
        ? const ShutdownWarningPage()
        : const MyHomePage(title: 'Go Sleep');

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}
