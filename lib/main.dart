import 'screens/lawyerScreens/lawyer_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_options.dart';
import 'package:provider/provider.dart';
import '/screens/auth/login_screen.dart';
import '/screens/home/user_home_screen.dart';
import '/screens/home/list_lawyer_screen.dart';
import '/screens/web/homepage_screen.dart';
import '/providers/subscription_provider.dart';
import '/providers/theme_provider.dart';
import '/providers/user_profile_provider.dart';
import '/providers/admin_provider.dart';
import '/widgets/auth_wrapper.dart';

// Export UserHomeScreen for use in other files
export '/screens/home/user_home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // If Firebase fails to initialize (e.g., missing options), app still runs.
  }
  runApp(DLawApp());
}

class DLawApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => AdminProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
          title: 'Nacase',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.green,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.green,
              secondary: Colors.black,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: Colors.green,
            colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(
              primary: Colors.green,
              secondary: Colors.greenAccent,
            ),
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
            switchTheme: const SwitchThemeData(thumbColor: WidgetStatePropertyAll(Colors.green)),
          ),
          themeMode: themeProvider.themeMode,
          home: kIsWeb ? const WebHomePage() : const AuthWrapper(),
          //const LawyerHomeScreen(),
          // const AuthWrapper(),
        ),
      ),
    );
  }
}
