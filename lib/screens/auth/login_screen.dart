import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qatar_data_app/database/controller/user_db_controller.dart';
import 'package:qatar_data_app/models/process_response.dart';
import 'package:qatar_data_app/preferences/shared_pref_controller.dart';
import 'package:qatar_data_app/provider/language_provider.dart';
import 'package:qatar_data_app/utils/helpers.dart';
import 'package:qatar_data_app/widgets/app_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Helpers {
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff205375),
        title: Text(
          AppLocalizations.of(context)!.login,
          style: GoogleFonts.nunito(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image(
                  image: const AssetImage('images/ui4.png'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.login_title,
                style: GoogleFonts.nunito(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  height: 0.8,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.login_subtitle,
                style: GoogleFonts.nunito(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AppTextField(
                textController: _emailTextController,
                hint: AppLocalizations.of(context)!.email,
                prefixIcon: Icons.email,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 20,
              ),
              AppTextField(
                textController: _passwordTextController,
                hint: AppLocalizations.of(context)!.password,
                prefixIcon: Icons.lock,
                textInputType: TextInputType.text,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (String value) {
                  //TODO:CALL Login Function
                },
              ),
              const SizedBox(
                height: 30,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xff205375),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 3),
                        color: Colors.black45,
                        blurRadius: 4,
                      )
                    ]),
                child: ElevatedButton(
                  onPressed: () async => await _performLogin(),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: Text(AppLocalizations.of(context)!.login),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.have_account,
                    style: GoogleFonts.nunito(),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/register_screen'),
                    child: Text(
                      AppLocalizations.of(context)!.create_account,
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<LanguageProvider>(context, listen: false)
              .changeLanguage();
        },
        backgroundColor: const Color(0xff205375),
        child: const Icon(
          Icons.language,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _performLogin() async {
    if (_checkData()) {
      await _login();
    }
  }

  bool _checkData() {
    if (_emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, message: 'Enter required data!', error: true);
    return false;
  }

  Future<void> _login() async {
    ProcessResponse processResponse = await UserDbController().login(
        email: _emailTextController.text,
        password: _passwordTextController.text);
    if (processResponse.success) {
      Navigator.pushReplacementNamed(context, '/home_screen');
    }
    showSnackBar(context,
        message: processResponse.message, error: !processResponse.success);
  }
}
