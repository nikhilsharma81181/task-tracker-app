import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/config/theme_const.dart';
import 'package:task_tracker/provider/comment_prov.dart';
import 'package:task_tracker/provider/login_prov.dart';
import 'package:task_tracker/provider/project_prov.dart';
import 'package:task_tracker/provider/task_prov.dart';
import 'package:task_tracker/provider/theme_prov.dart';
import 'package:task_tracker/view/Homepage/homepage.dart';
import 'package:task_tracker/view/auth/signin.dart';

import 'Services/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SavedSettings.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = context.watch<ThemeProvider>().themeMode;
    Future.delayed(const Duration(milliseconds: 200), () {
      context.read<UserProvider>().getUserData();
    });
    bool loggedIn = context.watch<UserProvider>().loggedIn;
    return MaterialApp(
      title: 'TaskTracker',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      home: loggedIn ? const Homepage() : const SignIn(),
    );
  }
}
