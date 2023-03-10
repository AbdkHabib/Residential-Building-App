import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qatar_data_app/preferences/shared_pref_controller.dart';
import 'package:qatar_data_app/utils/helpers.dart';
import 'package:qatar_data_app/widgets/app_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      String route =
          SharedPrefController().loggedIn ? '/home_screen' : '/login_screen';
      SharedPrefController().getValueFor<bool>(key: PrefKeys.loggedIn.name) ??
              false
          ? '/home_screen'
          : '/login_screen';
      Navigator.pushReplacementNamed(context, route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: AlignmentDirectional.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [
              Color(0xFF112B3C),
              Color(0xFFEFEFEF),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage('images/ui4.png'),
              ),
              SizedBox(height: 15,),
              Text(AppLocalizations.of(context)!.apartment,
              style: GoogleFonts.nunito(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
