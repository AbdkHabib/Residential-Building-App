import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:qatar_data_app/database/db_controller.dart';
import 'package:qatar_data_app/preferences/shared_pref_controller.dart';
import 'package:qatar_data_app/provider/language_provider.dart';
import 'package:qatar_data_app/provider/note_provider.dart';
import 'package:qatar_data_app/provider/resident_details_provider.dart';
import 'package:qatar_data_app/screens/app/home_screen.dart';
import 'package:qatar_data_app/screens/auth/login_screen.dart';
import 'package:qatar_data_app/screens/auth/register_screen.dart';
import 'package:qatar_data_app/screens/launch_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefController().initPref();
  await DbController().initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageProvider>(
            create: (context) => LanguageProvider()),
        ChangeNotifierProvider<NoteProvider>(
            create: (context) => NoteProvider()),
        ChangeNotifierProvider<ResidentDetailsProvider>(
            create: (context) => ResidentDetailsProvider()),
      ],
      builder: (context, widget) {
        return MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          // supportedLocales: AppLocalizations.supportedLocales,
          // locale: Locale(Provider.of<LanguageProvider>(context).language),
          locale: Locale(context.watch<LanguageProvider>().language),
          debugShowCheckedModeBanner: false,
          initialRoute: '/launch_screen',
          routes: {
            '/launch_screen': (context) => const LaunchScreen(),
            '/login_screen': (context) => const LoginScreen(),
            '/register_screen': (context) => const RegisterScreen(),
            '/home_screen': (context) => const HomeScreen(),
            '/resident_details_screen': (context) => const HomeScreen(),
            '/resident_home_screen': (context) => const HomeScreen(),
          },
        );
      },
    );
  }
}
