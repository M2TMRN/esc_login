import 'package:esc_login_game/ui/login_page.dart';
import 'package:esc_login_game/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChrome.setEnabledSystemUIOverlays([]);
      },
      child: MaterialApp(
          theme: ThemeData(
              brightness: Brightness.dark,
              dividerColor: Colors.transparent,
              visualDensity: VisualDensity.adaptivePlatformDensity),
          darkTheme: ThemeData(
              brightness: Brightness.dark,
              dividerColor: Colors.transparent,
              cardColor: BLACK_COLOR),
          themeMode: ThemeMode.dark,
          home: LoginPage(),

      ),
    );
  }

}
